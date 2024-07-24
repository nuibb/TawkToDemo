//
//  CDUser+CoreDataProperties.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var userName: String?
    @NSManaged public var avatar: String?
    @NSManaged public var company: String?
    @NSManaged public var blog: String?
    @NSManaged public var details: String?
    @NSManaged public var seen: Bool
    @NSManaged public var notes: String?
    @NSManaged public var followers: String?
    @NSManaged public var following: String?

}

extension CDUser : Identifiable {

}
