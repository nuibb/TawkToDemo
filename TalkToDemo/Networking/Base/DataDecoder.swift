//
//  Decoder.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol DataDecoder {
    func decode<T: DecodableCodingKeys>(_ data: Data) -> Swift.Result<T, DecodeError>
    func findAllProperties<T: DecodableCodingKeys>(_ data: Data, modelType: T.Type)
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
    
    func findAllProperties<T: DecodableCodingKeys>(_ data: Data, modelType: T.Type) {
        func extractKeys(from json: Any, parentKey: String = "") -> [String] {
            var keysSet = Set<String>()
            
            func helper(_ json: Any, parentKey: String) {
                if let dictionary = json as? [String: Any] {
                    for (key, value) in dictionary {
                        let fullKey = parentKey.isEmpty ? key : "\(parentKey).\(key)"
                        keysSet.insert(fullKey)
                        helper(value, parentKey: fullKey)
                    }
                } else if let array = json as? [Any], let firstItem = array.first {
                    helper(firstItem, parentKey: "\(parentKey)[*]")
                }
            }
            
            helper(json, parentKey: parentKey)
            return Array(keysSet.sorted())
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let extractedKeys = extractKeys(from: jsonObject)
                Logger.log(type: .info, "[Extracted][Keys]: \(extractedKeys)")
                Logger.log(type: .info, "[Model][Keys]: \(T.allKeys)")
                Logger.log(type: .info, "[Extracted][Keys] count: \(extractedKeys.count)")
                Logger.log(type: .info, "[Model][Keys] count: \(T.numberOfKeys)")
            }
        } catch {
            Logger.log(type: .error, "[JSON][Parsing] error: \(error)")
        }
    }
}
