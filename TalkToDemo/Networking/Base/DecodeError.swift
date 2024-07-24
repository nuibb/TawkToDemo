//
//  DecodeError.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

enum DecodeError: Error {
    case fileNotFound(String)
    case keyNotFound(String)
    case typeMismatch //(Any.Type)
    case valueNotFound //(Any.Type)
    case dataCorrupted
    case dataNotFound
    case decodingError(Error)
    
    var status: String {
        switch self {
        case .fileNotFound(let message):
            return message
        case .keyNotFound(let key):
            return Constants.keyNotFound.replace(with: key)
        case .typeMismatch:
            return Constants.typeMismatch
        case .valueNotFound:
            return Constants.valueNotFound
        case .dataCorrupted:
            return Constants.dataCorrupted
        case .dataNotFound:
            return Constants.dataNotFound
        case .decodingError(let error):
            return Constants.decodingError.replace(with: error.localizedDescription)
        }
    }
}
