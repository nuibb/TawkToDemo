//
//  User.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation

protocol User {
    var id: String { get }
    var name: String? { get }
    var username: String { get }
    var avatar: String? { get }
    var company: String? { get }
    var blog: String? { get }
    var details: String? { get }
    var seen: Bool { get set }
    var notes: String { get set }
    var followers: Int? { get }
    var following: Int? { get }
}
