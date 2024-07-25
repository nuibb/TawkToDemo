//
//  DataParser.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol DataParser: DataDecoder {
    func parse<T: DecodableCodingKeys>(
        endpoint: EndPoint,
        data: Data,
        response: URLResponse) -> Swift.Result<T, RequestError>
    
    func parse<T: DecodableCodingKeys>(
        endpoint: EndPoint,
        data: Data,
        response: URLResponse) -> Swift.Result<[T], RequestError>
}

extension DataParser {
    func parse<T: DecodableCodingKeys>(
        endpoint: EndPoint,
        data: Data,
        response: URLResponse) -> Swift.Result<T, RequestError> {
            
            //Logger.log(type: .error, "[API][Response]: \(response)")
            //Logger.log(type: .info, "[API][Data]: \(String(data: data, encoding: .utf8) ?? "No Data")")
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                let decodeResult: Result<T, DecodeError> = decode(data)
                return decodeResult.mapError { .decode($0) }
            case 401:
                return .failure(.unauthorized)
            case 400, 402...499, 500...599:
                return .failure(.unexpectedStatusCode)
            default:
                return .failure(.unknown)
            }
        }
    
    func parse<T: DecodableCodingKeys>(
        endpoint: EndPoint,
        data: Data,
        response: URLResponse) -> Swift.Result<[T], RequestError> {
            
            //Logger.log(type: .error, "[API][Response]: \(response)")
            //Logger.log(type: .info, "[API][Data]: \(String(data: data, encoding: .utf8) ?? "No Data")")
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                let decodeResult: Result<[T], DecodeError> = decode(data)
                return decodeResult.mapError { .decode($0) }
            case 401:
                return .failure(.unauthorized)
            case 400, 402...499, 500...599:
                return .failure(.unexpectedStatusCode)
            default:
                return .failure(.unknown)
            }
        }
}
