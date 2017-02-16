//
//  ViewModelServicesProtocol.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 13/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

public protocol ViewModelServicesDelegate: class {
    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent)
}

public protocol ViewModelServicesProtocol {
    var coreDataStack: CoreDataStack { get }
    var movement: MovementServiceProtocol { get }

    func push(_ viewModel: ViewModelProtocol)
    func pop(_ viewModel: ViewModelProtocol)
}
