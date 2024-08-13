//
//  UserService.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol UserService: HttpClient, NetworkRequestManaging {
    func getUsers(page: Int, size: Int, completion: @escaping (Swift.Result<[UserData], RequestError>) -> Void)
    
    func getUser(userName: String, completion: @escaping (Swift.Result<UserDetails, RequestError>) -> Void)
}

extension UserService {
    func getUsers(page: Int, size: Int, completion: @escaping (Swift.Result<[UserData], RequestError>) -> Void) {
        if self.networkMonitor.isConnected {
            enqueue({
                await self.getFrom(
                    endpoint: UserEndPoint.users(page: page, size: size),
                    model: UserData.self
                )
            }, completion: completion)
        } else {
            completion(.failure(.networkNotAvailable))
        }
    }
    
    func getUser(userName: String, completion: @escaping (Swift.Result<UserDetails, RequestError>) -> Void) {
        if self.networkMonitor.isConnected {
            enqueue({
                await self.getFrom(
                    endpoint: UserEndPoint.user(userName: userName),
                    model: UserDetails.self
                )
            }, completion: completion)
        } else {
            completion(.failure(.networkNotAvailable))
        }
    }
}
