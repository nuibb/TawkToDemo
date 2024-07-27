//
//  ProfileViewModel.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject, ResponseHandler {
    @Published var user: User
    @Published var isRequesting: Bool = false
    @Published var showToast: Bool = false
    
    var toastMessage: String = ""
    let remoteDataProvider: UserService
    private let localDataProvider: UserRepository
    private var cancellationTokens = Set<AnyCancellable>()
    
    init(user: User,
        remoteDataProvider: UserService,
        localDataProvider: UserRepository) {
            
        self.user = user
        self.remoteDataProvider = remoteDataProvider
        self.localDataProvider = localDataProvider
        
        self.getLocalUser()
        
        Utils.after(seconds: 1.0) { [weak self] in
            guard let self else { return }
            self.getUser()
        }
        
        self.addObservers()
    }
    
    private func addObservers() {
        $showToast
            .sink { [weak self] newValue in
                guard let self else { return }
                if !self.showToast, newValue {
                    RoutingService.shared.showFeedback(self.toastMessage)
                    self.showToast = false
                }
            }.store(in: &cancellationTokens)
    }
    
    func getLocalUser() {
        Task { [weak self] in
            guard let self = self else { return }
            let user = await self.localDataProvider.fetchUser(byIdentifier: self.user.id)
            if let user = user {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.user = user
                }
            }
        }
    }
    
    private func getUser() {
        self.isRequesting = true
        
        Task { [weak self] in
            guard let self, !self.user.username.isEmpty else { return }
            
            let response = await self.remoteDataProvider.getUser(userName: self.user.username)
            
            await self.handleResponse(response: response) { [weak self] result in
                guard let self else { return }
                //Logger.log(type: .info, "[User]: \(result)")
                let notes = self.user.notes
                self.user = result
                self.user.notes = notes
            }
        }
    }
    
    func updateNotes() {
        guard !self.user.notes.isEmpty else { return }
        
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.localDataProvider.updateUser(record: self.user)
            if result == .succeed {
                DispatchQueue.main.async {
                    RoutingService.shared.showFeedback(Constants.noteSavingSucceed)
                }
            }
        }
    }
}
