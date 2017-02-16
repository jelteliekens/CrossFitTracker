//
//  MovementOverviewViewModel.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public final class MovementTableViewModel: ViewModel {
    public let pagingList: PagingList

    public let createMovement: Action<(), CreateMovementViewModel, NoError>
    public let deleteMovement: Action<Movement, Bool, NoError>

    public let close: Action<(), (), NoError>

    public override init(services: ViewModelServicesProtocol) {
        pagingList = MovementFetchedResultController(managedContext: services.coreDataStack.mainContext)

        self.createMovement = Action<(), CreateMovementViewModel, NoError> { () -> SignalProducer<CreateMovementViewModel, NoError> in
            return SignalProducer(value: CreateMovementViewModel(services: services))
        }

        self.deleteMovement = Action<Movement, Bool, NoError> { movement -> SignalProducer<Bool, NoError> in
            return services.movement.delete(movement: movement)
        }

        self.close = Action<(), (), NoError> { _ in
            return SignalProducer<(), NoError>(value: ())
        }

        super.init(services: services)

        self.createMovement.values
            .observeValues(services.push)

        self.createMovement.values
            .flatMap(.latest) { vm in vm.create.values.map { _ in vm } }
            .observeValues(self.services.pop)

        self.createMovement.values
            .flatMap(.latest) { vm in vm.cancel.values.map { _ in vm } }
            .observeValues(self.services.pop)
    }
}
