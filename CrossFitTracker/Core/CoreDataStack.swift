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

    public lazy var managedContext: NSManagedObjectContext = {
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

    public func saveContext () {
        guard managedContext.hasChanges else { return }

        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
