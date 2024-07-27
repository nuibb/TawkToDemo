//
//  MockLocalDataProvider.swift
//  TalkToDemoTests
//
//  Created by Nurul Islam on 27/7/24.
//

import Foundation
import CoreData
@testable import TalkToDemo

class MockLocalDataProvider: UserRepository {
    var context: NSManagedObjectContext
    var mockUsers: [User] = []

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createUser(record: User) async -> StorageStatus {
        mockUsers.append(record)
        return .succeed
    }

    func deleteUser(byIdentifier id: String) async -> StorageStatus {
        mockUsers.removeAll { $0.id == id }
        return .succeed
    }

    func updateUser(record: User) async -> StorageStatus {
        if let index = mockUsers.firstIndex(where: { $0.id == record.id }) {
            mockUsers[index] = record
            return .succeed
        }
        return .notExistsInDB
    }

    func updateReadStatus(record: User) async -> StorageStatus {
        if let index = mockUsers.firstIndex(where: { $0.id == record.id }) {
            mockUsers[index].seen = true
            return .succeed
        }
        return .notExistsInDB
    }

    func fetchUsers() async -> [User] {
        return mockUsers
    }

    func fetchUser(byIdentifier id: String) async -> User? {
        return mockUsers.first { $0.id == id }
    }
}
