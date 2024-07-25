//
//  UserService.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol UserService: HttpClient {
    func getUsers(page: Int, size: Int) async -> Swift.Result<[UserData], RequestError>
    
    func getUser(userName: String) async -> Swift.Result<UserData, RequestError>
}

extension UserService {
    func getUsers(page: Int, size: Int) async -> Swift.Result<[UserData], RequestError> {
        if self.networkMonitor.isConnected {
            return await getFrom(
                endpoint: UserEndPoint.users(page: page, size: size),
                model: UserData.self
            )
        } else {
            return .failure(.networkNotAvailable)
        }
    }
    
    func getUser(userName: String) async -> Swift.Result<UserData, RequestError> {
        if self.networkMonitor.isConnected {
            return await getFor(
                endpoint: UserEndPoint.user(userName: userName),
                model: UserData.self
            )
        } else {
            return .failure(.networkNotAvailable)
        }
    }
}
