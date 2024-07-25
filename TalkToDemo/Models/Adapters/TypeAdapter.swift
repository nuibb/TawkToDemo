//
//  TypeAdapter.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation

extension UserData: User {
    var id: String {
        guard let userId = userId else { return UUID().uuidString }
        return String(userId)
    }
    var name: String? { nil }
    var username: String { login ?? "" }
    var avatar: String? { avatarUrl }
    var company: String? { nil }
    var blog: String? { nil }
    var details: String? { nil }
    var followers: Int? { nil }
    var following: Int? { nil }
    var seen: Bool {
        get { isSeen }
        set { isSeen = newValue }
    }
    var notes: String {
        get { noteData }
        set { noteData = newValue }
    }
}

extension UserDetails: User {
    var id: String {
        guard let userId = userId else { return UUID().uuidString }
        return String(userId)
    }
    var username: String { login ?? "" }
    var avatar: String? { avatarUrl }
    var details: String? { bio }
    var seen: Bool {
        get { isSeen }
        set { isSeen = newValue }
    }
    var notes: String {
        get { noteData }
        set { noteData = newValue }
    }
}
