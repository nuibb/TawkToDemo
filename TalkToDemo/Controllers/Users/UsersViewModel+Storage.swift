//
//  UsersViewModel+Storage.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation

extension UsersViewModel {
    func addLocalUsers(_ users: [User]) {
        guard !users.isEmpty else { return }
        
        Task { [weak self] in
            guard let self = self else { return }
            let episodes = await self.localDataProvider.fetchUsers()
            let existingUserIDs = episodes.map { $0.id }
            for user in users {
                if !existingUserIDs.contains(user.id) {
                    await self.localDataProvider.createUser(record: user)
                }
            }
            await self.localDataProvider.save()
        }
    }
    
    func getLocalUsers() {
        Task { [weak self] in
            guard let self = self else { return }
            let users = await self.localDataProvider.fetchUsers()
            
            guard !users.isEmpty else { return }
            Logger.log(type: .info, "[Storage][Users] count: \(users.count)")
            self.users = users
            self.filteredUsers = users
        }
    }
    
    func updateReadStatus(_ user: User) {
        guard !user.seen else { return }
        
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.localDataProvider.updateReadStatus(record: user)
            if result == .succeed {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let index = self.filteredUsers.firstIndex(where: { $0.id == user.id }) {
                        self.filteredUsers[index].seen = true
                        self.reload = true
                    }
                }
            }
            Logger.log(type: .info, "[Storage][User] updated")
        }
    }
}
