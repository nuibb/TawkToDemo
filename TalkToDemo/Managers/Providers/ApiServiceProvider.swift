//
//  ApiServiceProvider.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

struct ApiServiceProvider: DataProvider {
    let networkMonitor: NetworkMonitor = NetworkMonitor()
    var requestQueue = DispatchQueue(label: "com.TalkToDemo.networkRequestQueue")
    var isRequestInProgress = false
    
    static let shared = ApiServiceProvider()
    
    private init() {}
}
