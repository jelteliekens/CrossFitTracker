//
//  DataStoreController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 16/01/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import CoreData

open class CoreDataStack {

    let modelName: String

    public init(modelName: String) {
        self.modelName = modelName
    }

    public lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    public lazy var storeContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }

            debugPrint(storeDescription.url!)
        })

        return container
    }()

    public func newDerivedBackgroundContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }

    public func newDerivedMainContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = mainContext

        return context
    }

    public func saveContext() {
        saveContext(mainContext)
    }

    public func saveContext(_ context: NSManagedObjectContext) {
        if context !== mainContext {
            saveDerivedContext(context)
            return
        }

        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContext(self.mainContext)
        }
    }
}
