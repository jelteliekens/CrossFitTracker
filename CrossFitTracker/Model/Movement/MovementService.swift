//
//  MovementService.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 13/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import CoreData
import ReactiveSwift
import Result

public protocol MovementServiceProtocol {
    func create(name: String) -> SignalProducer<Movement, NoError>

    func delete(movement: Movement) -> SignalProducer<Bool, NoError>
}

public final class MovementService: MovementServiceProtocol {

    private let coreDataStack: CoreDataStack
//    private let storage: MovementStorage

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    public func create(name: String) -> SignalProducer<Movement, NoError> {
        let movement = Movement(context: coreDataStack.mainContext)
        movement.title = name
        coreDataStack.saveContext()
        return SignalProducer<Movement, NoError>(value: movement)
    }

    public func delete(movement: Movement) -> SignalProducer<Bool, NoError> {
        coreDataStack.mainContext.delete(movement)
        coreDataStack.saveContext()
        return SignalProducer<Bool, NoError>(value: true)
    }
}
