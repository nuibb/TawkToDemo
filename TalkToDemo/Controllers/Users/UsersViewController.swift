//
//  ViewController.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 19/7/24.
//

import UIKit

class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        self.tableView.register(UINib(nibName: "UserCellView", bundle: nil), forCellReuseIdentifier: "UserCellIdentifier")
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCellIdentifier", for: indexPath) as? UserCell 
        else { return UITableViewCell() }
        
        userCell.avatar.image = UIImage(systemName: "pencil.circle.fill")
        userCell.userName.text = "Test User " + String(indexPath.row)
        userCell.userDetails.text = "Test User Details " + String(indexPath.row)
        
        return userCell
    }
}

extension UsersViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RoutingService.shared.navigateToProfileView()
    }
}

