//
//  Dummy.swift
//  TalkToDemoTests
//
//  Created by Nurul Islam on 27/7/24.
//

import Foundation
@testable import TalkToDemo

class MockRemoteDataProvider: UserService {
    let networkMonitor: NetworkMonitor = NetworkMonitor()
    var mockUsers: [UserData] = []
    var mockUserDetails: UserDetails
    
    init(mockUserDetails: UserDetails) {
        self.mockUserDetails = mockUserDetails
    }
    
    func getUsers(page: Int, size: Int) async -> Swift.Result<[UserData], RequestError> {
        if self.networkMonitor.isConnected {
            return .success(mockUsers)
        } else {
            return .failure(.networkNotAvailable)
        }
    }
    
    func getUser(userName: String) async -> Swift.Result<UserDetails, RequestError> {
        if self.networkMonitor.isConnected {
            return .success(mockUserDetails)
        } else {
            return .failure(.networkNotAvailable)
        }
    }
}
