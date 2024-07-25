//
//  CodingKey.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol DecodableCodingKeys: Decodable {
    associatedtype CodingKeys: CodingKey & CaseIterable
    static var allKeys: Set<String> { get }
}

extension DecodableCodingKeys {
    static var allKeys: Set<String> {
        var keys = Set<String>()
        
        for key in CodingKeys.allCases {
            keys.insert(key.stringValue)
        }
        
        let instanceMirror = Mirror(reflecting: Self.self)
        for child in instanceMirror.children {
            if let keyProviderType = child.value as? any DecodableCodingKeys.Type {
                keys.formUnion(keyProviderType.allKeys)
            }
        }
        
        return keys
    }
    
    static var numberOfKeys: Int {
        return allKeys.count
    }
}
