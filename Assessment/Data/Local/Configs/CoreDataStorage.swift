//
//  CoreDataStorage.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import Foundation
import CoreData

final class CoreDataStorage {

    static let shared = CoreDataStorage()
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Assessment")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
