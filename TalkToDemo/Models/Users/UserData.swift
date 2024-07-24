//
//  User.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

struct UserData: DecodableCodingKeys, Equatable {
    var id: String = ""
    var name: String = ""
    var userName: String = ""
    let avatar: String?
    let company: String?
    let blog: String?
    var description: String = ""
    let followersCount: Int?
    let followingCount: Int?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "id"
        case name = "name"
        case userName = "userName"
        case avatar = "avatar"
        case company = "company"
        case blog = "blog"
        case description = "description"
        case followersCount = "followers"
        case followingCount = "following"
    }
    
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        lhs.id == rhs.id
    }
}
