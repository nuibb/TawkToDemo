//
//  PersistentStorage.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation
import CoreData

class PersistentStorage {
    static let shared = PersistentStorage()
    private let queue = DispatchQueue(label: "com.TalkTo.PersistentStorageQueue")
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                if Config.isProduction {
                    Logger.log(type: .error, "[Persistent][Storage][Save] failed: \(error.userInfo)")
                } else {
                    fatalError("[Persistent][Storage][Save] failed: \(error), \(error.userInfo)")
                }
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        queue.sync {
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    try context.save()
                    Logger.log(type: .info, "[Persistent][Storage][Save] Succeed!")
                } catch {
                    let error = error as NSError
                    if Config.isProduction {
                        Logger.log(type: .error, "[Persistent][Storage][Save] failed: \(error.userInfo)")
                    } else {
                        fatalError("[Persistent][Storage][Save] failed: \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        queue.sync {
            persistentContainer.performBackgroundTask { (backgroundContext) in
                block(backgroundContext)
                do {
                    try backgroundContext.save()
                } catch {
                    let error = error as NSError
                    if Config.isProduction {
                        Logger.log(type: .error, "[Persistent][Storage][Save] failed: \(error.userInfo)")
                    } else {
                        fatalError("[Persistent][Storage][Save] failed: \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
}


