//
//  EndPoint.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String:String] { get }
    var queryItems: [URLQueryItem]? { get }
}

extension EndPoint {
    var scheme: String {
        return Config.url.scheme
    }
    
    var host: String {
        return Config.url.host
    }
    
    var header: [String: String] {
        return [
            "Authorization": "Bearer \(Config.url.accessToken)",
            "Content-Type": Config.url.applicationType
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var components: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
}
