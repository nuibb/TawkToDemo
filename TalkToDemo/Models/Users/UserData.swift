//
//  User.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

struct UserData: DecodableCodingKeys, Equatable {
    var login : String?
    var userId : Int?
    var nodeId : String? = nil
    var avatarUrl : String? = nil
    var grAvatarId : String? = nil
    var url : String? = nil
    var htmlUrl : String? = nil
    var followersUrl : String? = nil
    var followingUrl : String? = nil
    var gistsUrl : String? = nil
    var starredUrl : String? = nil
    var subscriptionsUrl : String? = nil
    var organizationsUrl : String? = nil
    var reposUrl : String? = nil
    var eventsUrl : String? = nil
    var receivedEventsUrl : String? = nil
    var type : String? = nil
    var siteAdmin : Bool? = nil
    var isSeen: Bool = false
    var noteData: String = ""

    enum CodingKeys: String, CodingKey, CaseIterable {
        case login = "login"
        case userId = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case grAvatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }
    
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        lhs.username == rhs.username && lhs.userId == rhs.userId
    }
}
