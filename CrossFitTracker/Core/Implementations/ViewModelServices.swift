//
//  ViewModelServices.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 13/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

public final class ViewModelServices: ViewModelServicesProtocol {

    public let coreDataStack: CoreDataStack
    public let movement: MovementServiceProtocol

    private weak var delegate: ViewModelServicesDelegate?

    public init(delegate: ViewModelServicesDelegate?,
                coreDataStack: CoreDataStack,
                movement: MovementServiceProtocol) {
        self.delegate = delegate
        self.coreDataStack = coreDataStack
        self.movement = movement
    }

    public func push(_ viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: NavigationEvent(viewModel))
    }

    public func pop(_ viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: .pop)
    }
}
