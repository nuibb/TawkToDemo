//
//  Decoder.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol DataDecoder {
    func decode<T: DecodableCodingKeys>(_ data: Data) -> Swift.Result<T, DecodeError>
    
    func decode<T: DecodableCodingKeys>(_ data: Data) -> Swift.Result<[T], DecodeError>
}

extension DataDecoder {
    func decode<T: DecodableCodingKeys>(_ data: Data) -> Swift.Result<T, DecodeError> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.log(type: .error, "Key '\(key.stringValue)' not found: \(context.debugDescription)")
            return .failure(DecodeError.keyNotFound(key.stringValue))
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.log(type: .error, "Type '\(type)' mismatch: \(context.debugDescription) \(context.codingPath.debugDescription)")
            return .failure(DecodeError.typeMismatch)
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.log(type: .error, "Value '\(value)' not found: \(context.codingPath.description)")
            return .failure(DecodeError.valueNotFound)
        } catch let DecodingError.dataCorrupted(context) {
            Logger.log(type: .error, "Data corrupted: \(context.debugDescription) \(context.codingPath.debugDescription)")
            return .failure(DecodeError.dataCorrupted)
        } catch {
            Logger.log(type: .error, "Decoding error: \(error.localizedDescription)")
            return .failure(DecodeError.decodingError(error))
        }
    }
    
    func decode<T: DecodableCodingKeys>(_ data: Data) -> Swift.Result<[T], DecodeError> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([T].self, from: data)
            return .success(result)
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.log(type: .error, "Key '\(key.stringValue)' not found: \(context.debugDescription)")
            return .failure(DecodeError.keyNotFound(key.stringValue))
        } catch let DecodingError.typeMismatch(type, context) {
            debugPrint((String(data: data, encoding: .utf8) ?? "No Data"))
            Logger.log(type: .error, "Type '\(type)' mismatch: \(context.debugDescription) \(context.codingPath.debugDescription)")
            return .failure(DecodeError.typeMismatch)
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.log(type: .error, "Value '\(value)' not found: \(context.codingPath.description)")
            return .failure(DecodeError.valueNotFound)
        } catch let DecodingError.dataCorrupted(context) {
            Logger.log(type: .error, "Data corrupted: \(context.debugDescription) \(context.codingPath.debugDescription)")
            return .failure(DecodeError.dataCorrupted)
        } catch {
            Logger.log(type: .error, "Decoding error: \(error.localizedDescription)")
            return .failure(DecodeError.decodingError(error))
        }
    }
}
