//
//  UserResponse.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import Foundation

struct UserResponse: DecodableCodingKeys {
    let message: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case message = ""
    }
}
