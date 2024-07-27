//
//  UsersViewModelTest.swift
//  TalkToDemoTests
//
//  Created by Nurul Islam on 27/7/24.
//

import XCTest
import Combine
@testable import TalkToDemo

class UsersViewModelTests: XCTestCase {
    var viewModel: UsersViewModel!
    var mockLocalDataProvider: MockLocalDataProvider!
    var mockRemoteDataProvider: MockRemoteDataProvider!
    var testCoreDataStack: TestCoreDataStack!
    var cancellationTokens: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        testCoreDataStack = TestCoreDataStack.shared
        mockRemoteDataProvider = MockRemoteDataProvider(mockUserDetails: UserDetails(login: "testuser", userId: 0))
        mockLocalDataProvider = MockLocalDataProvider(context: testCoreDataStack.context)
        
        viewModel = UsersViewModel(
            remoteDataProvider: mockRemoteDataProvider,
            localDataProvider: mockLocalDataProvider
        )
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockLocalDataProvider = nil
        mockRemoteDataProvider = nil
        testCoreDataStack = nil
    }
    
    func testGetUsers_withSuccessfulResponse_Local() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch local users")
        let testUsers = [
            UserData(login: "testuser1", userId: 1),
            UserData(login: "testuser2", userId: 2)
        ]
        mockLocalDataProvider.mockUsers = testUsers
        viewModel.users = []
        viewModel.filteredUsers = []
        
        // Act
        viewModel.$filteredUsers
            .dropFirst()
            .sink { users in
                if users.count == testUsers.count {
                    expectation.fulfill()
                } else {
                    XCTFail("[Test] failed for: \(expectation.description)")
                }
            }
            .store(in: &cancellationTokens)
        
        viewModel.getLocalUsers()
        
        // Assert
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.username, "testuser1")
        XCTAssertEqual(viewModel.filteredUsers.count, 2)
    }
    
    func testGetUsers_withSuccessfulResponse_Remote() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch users with successful response")
        let testUsers = [
            UserData(login: "testuser1", userId: 1),
            UserData(login: "testuser2", userId: 2)
        ]
        mockRemoteDataProvider.mockUsers = testUsers
        mockRemoteDataProvider.networkMonitor.isConnected = true
        viewModel.users = []
        viewModel.filteredUsers = []

        // Act
        viewModel.$filteredUsers
            .dropFirst()
            .sink { users in
                if users.count == testUsers.count {
                    expectation.fulfill()
                } else {
                    XCTFail("[Test] failed for: \(expectation.description)")
                }
            }
            .store(in: &cancellationTokens)
        
        viewModel.getUsers()

        // Assert
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.username, "testuser1")
        XCTAssertEqual(viewModel.filteredUsers.count, 2)
        XCTAssertTrue(viewModel.loadMoreData)
    }

    func testGetUsers_withEmptyResponse() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch users with empty response")
        mockRemoteDataProvider.mockUsers = []
        mockRemoteDataProvider.networkMonitor.isConnected = true
        viewModel.users = []
        viewModel.filteredUsers = []

        // Act
        viewModel.$isRequesting
            .sink { [weak self] newValue in
                guard let self else { return }
                if self.viewModel.isRequesting && !newValue {
                    expectation.fulfill()
                }
            }.store(in: &cancellationTokens)
        
        viewModel.getUsers()

        // Assert
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
    }

    func test_UsersViewModel_when_network_is_unavailable() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Network error expectation")
        let page = 0
        let size = 10
        
        /// Simulating network not availability error response
        mockRemoteDataProvider.networkMonitor.isConnected = false

        // Act
        Task { [weak self] in
            guard let self = self else { return }
            let response = await mockRemoteDataProvider.getUsers(page: page, size: size)
            if case .success(_) = response {
                XCTFail("Expected network to be unavailable")
            } else if case .failure(let error) = response {
                XCTAssertEqual(error.status, RequestError.networkNotAvailable.status)
                expectation.fulfill()
            } else {
                XCTFail("Expected network to be unavailable")
            }
        }

        // Assert
        await fulfillment(of: [expectation], timeout: 5)
    }
}
