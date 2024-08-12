//
//  UsersViewModel.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    @Published var isRequesting: Bool = false
    @Published var showToast: Bool = false
    @Published var lastUserId: Int = 0
    @Published var reload: Bool = false
    
    @Published var filteredUsers: [User] = []
    var users: [User] = []
    
    var toastMessage: String = ""
    var pageSize = 10
    
    private var cancellationTokens = Set<AnyCancellable>()
    internal let remoteDataProvider: UserService
    internal let localDataProvider: UserRepository
    
    init(remoteDataProvider: UserService, localDataProvider: UserRepository) {
        self.remoteDataProvider = remoteDataProvider
        self.localDataProvider = localDataProvider
        
        self.addObservers()
    }
    
    func loadData() {
        self.getLocalUsers()
        Utils.after(seconds: 1.0) { [weak self] in
            guard let self = self else { return }
            self.getUsers()
        }
    }
    
    private func addObservers() {
        /// Pagination while pageIndex is being changed
        $lastUserId
            .sink { [weak self] newValue in
                guard let self else { return }
                if newValue > 0, self.lastUserId != newValue {
                    self.getUsers()
                }
            }.store(in: &cancellationTokens)
        
        /// Automatically retry loading data once the connection is available.
        self.remoteDataProvider.networkMonitor.$isConnected
            .sink { [weak self] status in
                guard let self else { return }
                if self.remoteDataProvider.networkMonitor.isConnected != status,
                   self.remoteDataProvider.networkMonitor.isConnected {
                    self.lastUserId = 0 /// probable bug, fix later
                }
            }.store(in: &cancellationTokens)
        
        /// Show toast
        $showToast
            .sink { [weak self] newValue in
                guard let self else { return }
                if !self.showToast, newValue {
                    RoutingService.shared.showFeedback(self.toastMessage)
                    self.showToast = false
                }
            }.store(in: &cancellationTokens)
    }
    
    private func getUsers() {
        self.isRequesting = true
        
        self.remoteDataProvider.getUsers(
            page: self.lastUserId,
            size: self.pageSize) { [weak self] result in
                
            guard let self = self else { return }
            self.isRequesting = false
            
            switch result {
            case .success(let users):
                let initialCount = self.users.count
                self.addUniqueUsers(users)
                
                if self.users.count > initialCount {
                    self.filteredUsers = self.users
                    self.reload = true
                    self.addLocalUsers(users)
                }
            case .failure(let error):
                Logger.log(type: .error, "[API][Request] failed: \(error.status)")
                self.displayMessage(error.status)
            }
        }
    }
    
    private func displayMessage(_ msg: String) {
        self.toastMessage = msg
        self.showToast = true
        
        Utils.after(seconds: 5.0) { [weak self] in
            guard let self else { return }
            self.toastMessage = ""
        }
    }
    
    func addUniqueUsers(_ newUsers: [User]) {
        let existingUserIDs = Set(self.users.map { $0.id })
        for user in newUsers {
            if !existingUserIDs.contains(user.id) {
                self.users.append(user)
            }
        }
    }
}
