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

public final class MovementOverviewViewModel: ViewModel {
    public let pagingList: PagingList

    public let createMovement: Action<CreateMovementViewController, CreateMovementViewModel, NoError>
    public let deleteMovement: Action<Movement, Bool, NoError>

    public let close: Action<(), (), NoError>

    public override init(services: ViewModelServicesProtocol) {
        pagingList = MovementFetchedResultController(managedContext: services.coreDataStack.managedContext)

        self.createMovement = Action<CreateMovementViewController, CreateMovementViewModel, NoError> { createMovementViewController -> SignalProducer<CreateMovementViewModel, NoError> in
            let createMovementViewModel = CreateMovementViewModel(services: services)
            createMovementViewController.viewModel = createMovementViewModel
            return SignalProducer<CreateMovementViewModel, NoError>(value: createMovementViewModel)
        }

        self.deleteMovement = Action<Movement, Bool, NoError> { movement -> SignalProducer<Bool, NoError> in
            return services.movement.delete(movement: movement)
        }

        self.close = Action<(), (), NoError> { _ in
            return SignalProducer<(), NoError>(value: ())
        }

        super.init(services: services)

        self.createMovement.values
            .flatMap(FlattenStrategy.latest) { vm in
                vm.create.values
            }
            .observeValues { _ in
                self.close.apply().start()
        }

        self.createMovement.values
            .flatMap(FlattenStrategy.latest) { vm in
                vm.cancel.values
            }
            .observeValues { _ in
                self.close.apply().start()
            }
    }
}
