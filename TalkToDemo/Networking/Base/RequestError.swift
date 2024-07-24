//
//  RequestError.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

enum RequestError: Error {
    case encode
    case decode(DecodeError)
    case invalidURL
    case requestFailed
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case networkNotAvailable
    case tokenNotFound
    case custom(String)
    case parsingFailed
    case unknown
    
    var status: String {
        switch self {
        case .encode:
            return Constants.encodeError
        case .decode(let error):
            return error.status
        case .invalidURL:
            return Constants.invalidURLError
        case .requestFailed:
            return Constants.requestFailedError
        case .noResponse:
            return Constants.noResponseError
        case .unauthorized:
            return Constants.unauthorizedError
        case .unexpectedStatusCode:
            return Constants.unexpectedStatusCodeError
        case .networkNotAvailable:
            return Constants.networkNotAvailable
        case .tokenNotFound:
            return Constants.tokenNotFoundError
        case .custom(let message):
            return message
        case .parsingFailed:
            return Constants.parsingFailedError
        default:
            return Constants.defaultError
        }
    }
}

extension RequestError: Equatable {
    static func ==(lhs: RequestError, rhs: RequestError) -> Bool {
        return lhs.status == rhs.status
    }
}
