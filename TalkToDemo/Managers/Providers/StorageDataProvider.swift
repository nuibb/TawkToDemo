//
//  StorageDataProvider.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation
import CoreData

struct StorageDataProvider: UserRepository {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
