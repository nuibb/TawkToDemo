//
//  CoreDataModelTest.swift
//  TalkToDemoTests
//
//  Created by Nurul Islam on 28/7/24.
//

import Foundation
import XCTest
import CoreData
@testable import TalkToDemo

class CoreDataModelTests: XCTestCase {
    var testCoreDataStack: TestCoreDataStack!
    var mockLocalDataProvider: MockLocalDataProvider!

    override func setUpWithError() throws {
        testCoreDataStack = TestCoreDataStack.shared
        mockLocalDataProvider = MockLocalDataProvider(context: testCoreDataStack.context)
    }

    override func tearDownWithError() throws {
        testCoreDataStack = nil
        mockLocalDataProvider = nil
    }

    func testCreateUser() async throws {
        // Arrange
        let user = UserData(login: "testuser1", userId: 1)

        // Act
        let status = await mockLocalDataProvider.createUser(record: user)
        let fetchedUser = await mockLocalDataProvider.fetchUser(byIdentifier: "1")

        // Assert
        XCTAssertEqual(status, StorageStatus.succeed)
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.username, "testuser1")
    }

    func testUpdateUser() async throws {
        // Arrange
        let user = UserData(login: "testuser1", userId: 1)
        let _ = await mockLocalDataProvider.createUser(record: user)

        // Act
        var updatedUser = user
        updatedUser.userId = 2
        let status = await mockLocalDataProvider.updateUser(record: updatedUser)
        let fetchedUser = await mockLocalDataProvider.fetchUser(byIdentifier: "1")

        // Assert
        XCTAssertEqual(status, StorageStatus.succeed)
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.id, "2")
    }

    func testDeleteUser() async throws {
        // Arrange
        let user = UserData(login: "testuser1", userId: 1)
        let _ = await mockLocalDataProvider.createUser(record: user)

        // Act
        let status = await mockLocalDataProvider.deleteUser(byIdentifier: "1")
        let fetchedUser = await mockLocalDataProvider.fetchUser(byIdentifier: "1")

        // Assert
        XCTAssertEqual(status, StorageStatus.succeed)
        XCTAssertNil(fetchedUser)
    }
}
