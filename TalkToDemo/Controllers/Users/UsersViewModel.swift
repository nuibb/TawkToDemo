//
//  UsersViewModel.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import Combine

final class UsersViewModel: ObservableObject, ResponseHandler {
    @Published var isRequesting: Bool = false
    @Published var showToast: Bool = false
    @Published var pageIndex: Int = 0
    @Published var reload: Bool = false
    
    @Published var filteredUsers: [User] = []
    var users: [User] = []
    
    var toastMessage: String = ""
    var pageSize = 10
    
    private var cancellationTokens = Set<AnyCancellable>()
    private let remoteDataProvider: UserService
    internal let localDataProvider: UserRepository
    
    init(remoteDataProvider: UserService, localDataProvider: UserRepository) {
        self.remoteDataProvider = remoteDataProvider
        self.localDataProvider = localDataProvider
        
        self.getLocalUsers()
        
        Utils.after(seconds: 1.0) { [weak self] in
            guard let self else { return }
            self.getUsers()
        }
        
        self.addObservers()
    }
    
    private func addObservers() {
        /// Pagination while pageIndex is being changed
        $pageIndex
            .sink { [weak self] newIndex in
                guard let self else { return }
                if newIndex > self.pageIndex {
                    self.getUsers()
                }
            }.store(in: &cancellationTokens)
        
        /// Automatically retry loading data once the connection is available.
        self.remoteDataProvider.networkMonitor.$isConnected
            .sink { [weak self] status in
                guard let self else { return }
                if self.remoteDataProvider.networkMonitor.isConnected != status,
                   self.remoteDataProvider.networkMonitor.isConnected {
                    self.pageIndex = 0 /// probable bug, fix later
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
        
        Task { [weak self] in
            guard let self else { return }
            let response = await self.remoteDataProvider.getUsers(
                page: pageIndex,
                size: pageSize
            )
            await self.handleResponse(response: response) { [weak self] result in
                guard let self, !result.isEmpty else { return }
                
                Logger.log(type: .info, "[Users] count: \(result.count)")
                
                if pageIndex > 0 && !self.users.isEmpty {
                    self.users.append(contentsOf: result)
                } else {
                    self.users = result
                }
                
                self.filteredUsers = self.users
                self.reload = true

                /// Save in DB
                self.addLocalUsers(users)
            }
        }
    }
}
