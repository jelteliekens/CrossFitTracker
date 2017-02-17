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

    func getAll() -> SignalProducer<[Movement], NoError>

    func create(name: String) -> SignalProducer<Movement, NoError>

    func delete(movement: Movement) -> SignalProducer<Bool, NoError>
}

public final class MovementService: MovementServiceProtocol {

    private let storage: MovementStorageProtocol

    public init(storage: MovementStorageProtocol) {
        self.storage = storage
    }

    public func getAll() -> SignalProducer<[Movement], NoError> {
        let movements = storage.getAll().map { persisted in
            Movement(id: Int(persisted.unique), name: persisted.name)
        }

        return SignalProducer(value: movements)
    }

    public func create(name: String) -> SignalProducer<Movement, NoError> {
        let movement = Movement(id: 0, name: name)

        storage.create(movement)

        return SignalProducer<Movement, NoError>(value: movement)
    }

    public func delete(movement: Movement) -> SignalProducer<Bool, NoError> {
//        coreDataStack.mainContext.delete(movement)
//        coreDataStack.saveContext()
        return SignalProducer<Bool, NoError>(value: true)
    }
}
