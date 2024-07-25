//
//  ProfileEndPoint.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

enum UserEndPoint: EndPoint {
    case users(page: Int, size: Int)
    case user(userName: String)
}

extension UserEndPoint {
    
    // MARK: path includes a leading '/'
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .user(let userName):
            return "/users/" + userName
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .users, .user:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .users(let page, let size):
            return [
                URLQueryItem(name: "since", value: String(page))
                //URLQueryItem(name: "size", value: String(size))
            ]
        default:
            return nil
        }
    }
}
