//
//  NetworkManager.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 12/8/24.
//

import Foundation

protocol NetworkRequestManaging {
    var requestQueue: DispatchQueue { get }
    
    func enqueue<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<[T], RequestError>,
        completion: @escaping (Swift.Result<[T], RequestError>) -> Void
    )
    
    func enqueue<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<T, RequestError>,
        completion: @escaping (Swift.Result<T, RequestError>) -> Void
    )
}

extension NetworkRequestManaging {
    func enqueue<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<[T], RequestError>,
        completion: @escaping (Swift.Result<[T], RequestError>) -> Void
    ) {
        requestQueue.async { [self] in
            self.executeRequest(request, completion: completion)
        }
    }
    
    func enqueue<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<T, RequestError>,
        completion: @escaping (Swift.Result<T, RequestError>) -> Void
    ) {
        requestQueue.async { [self] in
            self.executeRequest(request, completion: completion)
        }
    }
    
    func executeRequest<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<[T], RequestError>,
        completion: @escaping (Swift.Result<[T], RequestError>) -> Void
    ) {
        Task {
            let result = await request()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func executeRequest<T: DecodableCodingKeys>(
        _ request: @escaping () async -> Swift.Result<T, RequestError>,
        completion: @escaping (Swift.Result<T, RequestError>) -> Void
    ) {
        Task {
            let result = await request()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
