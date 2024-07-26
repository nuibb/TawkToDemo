//
//  ViewController.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 19/7/24.
//

import UIKit
import Combine

class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var cancellationTokens = Set<AnyCancellable>()
    private let viewModel = UsersViewModel(
        remoteDataProvider: ApiServiceProvider.shared,
        localDataProvider: StorageDataProvider(
            context: PersistentStorage.shared.context
        )
    )
    
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.searchTextField.textColor = UIColor.text
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.configurations()
        
        self.spinner.layer.zPosition = 1
        self.spinner.isHidden = true
        
        self.initObservers()
    }
    
    private func configurations() {
        self.tableView.rowHeight = 80
        self.tableView.tableHeaderView = searchController.searchBar
        
        for cell in CellIdentifier.allCases {
            self.tableView.register(UINib(nibName: cell.description, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    // MARK: Observers
    private func initObservers() {
        viewModel.$isRequesting
            .sink { [weak self] newValue in
                guard let self else { return }
                if viewModel.isRequesting && !newValue {
                    self.hideLoading()
                } else if !viewModel.isRequesting && newValue {
                    self.showLoading()
                }
            }.store(in: &cancellationTokens)
        
        viewModel.$reload
            .sink { [weak self] newValue in
                guard let self else { return }
                if newValue {
                    self.tableView.reloadData()
                    self.viewModel.reload = false
                }
            }.store(in: &cancellationTokens)
    }
    
    private func showLoading() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    private func hideLoading() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < viewModel.filteredUsers.count else {
            return UITableViewCell()
        }
        
        let user = viewModel.filteredUsers[indexPath.row]
        let cellIdentifier = cellIdentifierFor(user: user, at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: user)
        
        if let last = self.viewModel.users.last,
            user.id == last.id,
           !spinner.isAnimating,
            viewModel.loadMoreData,
           !searchController.isActive {
            viewModel.pageIndex += 1
        }
        
        return cell as! UITableViewCell
    }
}

extension UsersViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < viewModel.filteredUsers.count, !spinner.isAnimating
        else { return }
        
        let user = self.viewModel.filteredUsers[indexPath.row]
        viewModel.updateReadStatus(user)
        RoutingService.shared.navigateToProfileView(user)
    }
}

// MARK: - UISearchView
extension UsersViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.filterUsers(with: searchText)
        } else {
            self.filterUsers(with: "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filterUsers(with: "")
    }
    
    private func filterUsers(with searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredUsers = viewModel.users
        } else {
            viewModel.filteredUsers = viewModel.users.filter { user in
                let lowercasedSearchText = searchText.lowercased()
                let lowercasedUsername = user.username.lowercased()
                let lowercasedNotes = user.notes.lowercased()
                
                return lowercasedUsername.contains(lowercasedSearchText) ||
                lowercasedNotes.contains(lowercasedSearchText)
            }
        }
        
        self.tableView.reloadData()
    }
}

extension UsersViewController {
    private func cellIdentifierFor(user: User, at indexPath: IndexPath) -> String {
        if !user.notes.isEmpty {
            return CellIdentifier.notes.identifier
        } else if indexPath.row % 4 == 3 {
            return CellIdentifier.inverted.identifier
        } else {
            return CellIdentifier.normal.identifier
        }
    }
}
