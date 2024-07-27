//
//  UserDetails.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import Foundation

struct UserDetails: DecodableCodingKeys, Equatable {
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
    var name: String? = nil
    var company : String? = nil
    var blog : String? = nil
    var location : String? = nil
    var email : String? = nil
    var hireable : Bool? = nil
    var bio : String? = nil
    var twitterUsername : String? = nil
    var publicRepos : Int? = nil
    var publicGists : Int? = nil
    var followers : Int? = nil
    var following : Int? = nil
    var createdAt : String? = nil
    var updatedAt : String? = nil
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

