//
//  Persistence.swift
//  Shared
//
//  Created by Cameron Delong on 8/7/21.
//

import CoreData

struct PersistenceController {
    // MARK: Properties
    /// A singleton instance of `PersistenceController`.
    static let shared = PersistenceController()
    
    /// An instance of `PersistenceController` to use in previews.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newInstance = Instance(context: viewContext)
            newInstance.name = "name"
            newInstance.puzzle = ._3x3
            newInstance.order = Int16(i)
            newInstance.primaryStatistic = Statistic(kind: .average, modifier: 5)
            newInstance.secondaryStatistic = Statistic(kind: .average, modifier: 12)
        }
        
        PersistenceController.save()

        return result
    }()

    /// The view context of the singleton instance of `PersistenceController`.
    static var viewContext: NSManagedObjectContext {
        return Self.shared.container.viewContext
    }

    /// The instance of `NSPersistentContainer` for persistence.
    let container: NSPersistentContainer

    // MARK: Initializers
    /// Creates an instance of `PersistenceController`.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Cubing_Timer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: Methods
    /// Saves the viewContext if it has any changes.
    static func save() {
        if PersistenceController.viewContext.hasChanges {
            try? PersistenceController.viewContext.save()
            // TODO: Add error handling
        }
    }
}
