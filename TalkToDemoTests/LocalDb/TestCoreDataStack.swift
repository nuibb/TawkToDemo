//
//  TestCoreDataStack.swift
//  TalkToDemoTests
//
//  Created by Nurul Islam on 27/7/24.
//

import XCTest
import CoreData
@testable import TalkToDemo

class TestCoreDataStack {
    static let shared = TestCoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            assert(error == nil)
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
    }
}
