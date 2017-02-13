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
}

public final class MovementService: MovementServiceProtocol {

    private let coreDataStack: CoreDataStack
//    private let storage: MovementStorage

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    public func create(name: String) -> SignalProducer<Movement, NoError> {
        debugPrint(name)
        let movement = Movement(context: coreDataStack.managedContext)
        movement.title = name
        coreDataStack.saveContext()
        return SignalProducer<Movement, NoError>(value: movement)
    }
}
