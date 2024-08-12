//
//  ProfileViewModel.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
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
    
    private func getUser() {
        self.isRequesting = true
        guard !self.user.username.isEmpty else {
            self.isRequesting = false
            return
        }
        
        self.remoteDataProvider.getUser(userName: self.user.username) { [weak self] response in
            
            guard let self = self else { return }
            self.isRequesting = false
            
            switch response {
            case .success(let user):
                // Logger.log(type: .info, "[User]: \(user)")
                let notes = self.user.notes
                self.user = user
                self.user.notes = notes
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
