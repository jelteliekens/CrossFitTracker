//
//  MovementStorage.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 13/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import CoreData

public protocol MovementStorageProtocol {

    func getAll() -> [PersistedMovement]

    @discardableResult
    func create(_ movement: Movement) -> PersistedMovement
}

public final class MovementStorage: MovementStorageProtocol {

    private let coreDataStack: CoreDataStack

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    public func getAll() -> [PersistedMovement] {
        let fetchRequest: NSFetchRequest<PersistedMovement> = PersistedMovement.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PersistedMovement.name),
                                    ascending: true,
                                    selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sort]

        do {
            return try coreDataStack.mainContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    public func create(_ movement: Movement) -> PersistedMovement {
        let context = coreDataStack.newDerivedBackgroundContext()
        let persisted = PersistedMovement(context: context)
        persisted.unique = Int32(movement.id)
        persisted.name = movement.name
        coreDataStack.saveContext(context)
        return persisted
    }
}
