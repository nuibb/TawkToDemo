//
//  UserDetails.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import Foundation

struct UserDetails: DecodableCodingKeys, Equatable {
    let login : String?
    var userId : Int?
    let nodeId : String?
    let avatarUrl : String?
    let grAvatarId : String?
    let url : String?
    let htmlUrl : String?
    let followersUrl : String?
    let followingUrl : String?
    let gistsUrl : String?
    let starredUrl : String?
    let subscriptionsUrl : String?
    let organizationsUrl : String?
    let reposUrl : String?
    let eventsUrl : String?
    let receivedEventsUrl : String?
    let type : String?
    let siteAdmin : Bool?
    let name: String?
    let company : String?
    let blog : String?
    let location : String?
    let email : String?
    let hireable : String?
    let bio : String?
    let twitterUsername : String?
    let publicRepos : Int?
    let publicGists : Int?
    let followers : Int?
    let following : Int?
    let createdAt : String?
    let updatedAt : String?
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
        case name = "name"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case email = "email"
        case hireable = "hireable"
        case bio = "bio"
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers = "followers"
        case following = "following"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static func == (lhs: UserDetails, rhs: UserDetails) -> Bool {
        lhs.username == rhs.username && lhs.userId == rhs.userId
    }
}

