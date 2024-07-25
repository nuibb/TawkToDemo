//
//  HttpClient.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol HttpClient: DataParser, NetworkMonitorService {
    func getFrom<T: DecodableCodingKeys>(endpoint: EndPoint, model: T.Type) async -> Swift.Result<[T], RequestError>
    
    func getFor<T: DecodableCodingKeys>(endpoint: EndPoint, model: T.Type) async -> Swift.Result<T, RequestError>
    
    func postFor<T: DecodableCodingKeys, T2: Encodable>(endpoint: EndPoint, payload: T2, model: T.Type) async -> Swift.Result<T, RequestError>
    
    func postFor<T: DecodableCodingKeys>(endpoint: EndPoint, file: URL, model: T.Type) async -> Swift.Result<T, RequestError>
    
    func download(from: URL) async -> Swift.Result<Bool, RequestError>
    func download(for: URLRequest) async -> Swift.Result<Bool, RequestError>
    func download(resumeFrom: Data) async -> Swift.Result<Bool, RequestError>
}

extension HttpClient {
    func getFrom<T: DecodableCodingKeys>(endpoint: EndPoint, model: T.Type) async -> Swift.Result<[T], RequestError> {
        guard let url = endpoint.components.url else { return .failure(.invalidURL) }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return parse(endpoint: endpoint, data: data, response: response)
        } catch (let error ) {
            Logger.log(type: .error, "[API][Request] failed: \(error.localizedDescription)")
            return .failure(.requestFailed)
        }
    }
    
    func getFor<T: DecodableCodingKeys>(endpoint: EndPoint, model: T.Type) async -> Swift.Result<T, RequestError> {
        guard let url = endpoint.components.url else { return .failure(.invalidURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return parse(endpoint: endpoint, data: data, response: response)
        } catch (let error ) {
            Logger.log(type: .error, "[API][Request] failed: \(error.localizedDescription)")
            return .failure(.requestFailed)
        }
    }
    
    func postFor<T: DecodableCodingKeys, T2: Encodable>(endpoint: EndPoint, payload: T2, model: T.Type) async -> Swift.Result<T, RequestError> {
        guard let url = endpoint.components.url else { return .failure(.invalidURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let payload = try? encoder.encode(payload) else { return .failure(.encode) }
        //Logger.log(type: .info, "[API][Payload]: \(String(data: payload, encoding: .utf8) ?? "Invalid Payload")")
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: payload)
            return parse(endpoint: endpoint, data: data, response: response)
        } catch (let error ) {
            Logger.log(type: .error, "[API][Request] failed: \(error.localizedDescription)")
            return .failure(.requestFailed)
        }
    }
    
    func postFor<T: DecodableCodingKeys>(endpoint: EndPoint, file: URL, model: T.Type) async -> Swift.Result<T, RequestError> {
        return .failure(.unknown)
    }
    
    func download(from: URL) async -> Swift.Result<Bool, RequestError> {
        return .failure(.unknown)
    }
    
    func download(for: URLRequest) async -> Swift.Result<Bool, RequestError> {
        return .failure(.unknown)
    }
    
    func download(resumeFrom: Data) async -> Swift.Result<Bool, RequestError> {
        return .failure(.unknown)
    }
}
