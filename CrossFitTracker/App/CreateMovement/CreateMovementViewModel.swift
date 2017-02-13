//
//  CreateMovementViewModel.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public final class CreateMovemenViewModel: ViewModel {

    public let movement = MutableProperty<String>("")

    public let create: Action<String, Movement, NoError>
    public let cancel: Action<(), (), NoError>

    public override init(services: ViewModelServicesProtocol) {
        let createEnabled = MutableProperty(false)

        self.create = Action<String, Movement, NoError>(enabledIf: createEnabled) { (movement: String) -> SignalProducer<Movement, NoError> in
            return services.movement.create(name: movement)
        }

        self.cancel = Action<(), (), NoError> {
            return SignalProducer<(), NoError>(value: ())
        }

        createEnabled <~ self.movement.producer.map({ (movement) -> Bool in
            return !movement.isEmpty
        })

        super.init(services: services)
    }
}
