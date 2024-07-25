//
//  TypeAdapter.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation

extension UserData: Identifiable, User {
    var id: String {
        let userId = userId ?? 0
        let uniqueId = String(userId) + username
        return uniqueId == "0" ? UUID().uuidString : uniqueId
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

extension UserDetails: Identifiable, User {
    var id: String {
        let userId = userId ?? 0
        let uniqueId = String(userId) + username
        return uniqueId == "0" ? UUID().uuidString : uniqueId
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
