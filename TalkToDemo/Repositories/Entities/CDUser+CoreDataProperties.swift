//
//  CDUser+CoreDataProperties.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 12/8/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var details: String?
    @NSManaged public var followers_count: Int64
    @NSManaged public var following_count: Int64
    @NSManaged public var userId: String
    @NSManaged public var name: String?
    @NSManaged public var notes: String
    @NSManaged public var seen: Bool
    @NSManaged public var username: String
}

extension CDUser: Identifiable, User {
    public var id: String {
        let uniqueId = userId + username
        return uniqueId == "0" ? UUID().uuidString : uniqueId
    }
    var actualId: Int { Int(userId) ?? 0 }
    var followers: Int? { Int(followers_count) }
    var following: Int? { Int(following_count) }
}
