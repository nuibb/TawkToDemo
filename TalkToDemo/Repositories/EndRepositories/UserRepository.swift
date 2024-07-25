//
//  UserRepository.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation
import CoreData

protocol UserRepository: BaseRepository {
    @discardableResult func createUser(record: T1) async -> StorageStatus
    @discardableResult func deleteUser(byIdentifier id: String) async -> StorageStatus
    
    func updateUser(record: T1) async -> StorageStatus
    func updateReadStatus(record: T1) async -> StorageStatus
    func fetchUsers() async -> [T1]
    func fetchUser(byIdentifier id: String) async -> T1?
}

extension UserRepository {
    typealias T = CDUser
    typealias T1 = User
    
    @discardableResult
    func createUser(record: T1) async -> StorageStatus {
        guard let cdUser = await self.create(T.self) else { return .insertionFailed }
        cdUser.id = record.id
        cdUser.name = record.name
        cdUser.username = record.username
        cdUser.avatar = record.avatar
        cdUser.company = record.company
        cdUser.blog = record.blog
        cdUser.details = record.details
        cdUser.seen = record.seen
        cdUser.notes = record.notes
        cdUser.followers_count = Int64(record.followers ?? 0)
        cdUser.following_count = Int64(record.following ?? 0)
        return .succeed
    }
    
    func fetchUsers() async -> [T1] {
        let results = await self.fetch(T.self)
        var users: [T1] = []
        results.forEach({ cdUser in
            users.append(cdUser)
        })
        return users
    }
    
    func fetchUser(byIdentifier id: String) async -> T1? {
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        //let descriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let results = await self.fetch(T.self, with: predicate)//sort: descriptors
        guard let user = results.first else { return nil }
        return user
    }
    
    func updateUser(record: T1) async -> StorageStatus {
        debugPrint(record.notes)
        let predicate = NSPredicate(format: "(id = %@)", record.id as CVarArg)
        let results = await self.fetch(T.self, with: predicate)
        
        guard !results.isEmpty, let cdUser = results.first else { return .notExistsInDB }
        cdUser.notes = record.notes
        await self.save()
        return .succeed
    }
    
    func updateReadStatus(record: T1) async -> StorageStatus {
        let predicate = NSPredicate(format: "(id = %@)", record.id as CVarArg)
        let results = await self.fetch(T.self, with: predicate)
        
        guard !results.isEmpty, let cdUser = results.first else { return .notExistsInDB }
        cdUser.seen = true
        await self.save()
        return .succeed
    }
    
    @discardableResult
    func deleteUser(byIdentifier id: String) async -> StorageStatus {
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        let results = await self.fetch(T.self, with: predicate)
        guard let cdUser = results.first else { return .notExistsInDB }
        await self.delete(object: cdUser)
        return .succeed
    }
}


