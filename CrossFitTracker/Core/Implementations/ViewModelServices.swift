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

    public init(coreDataStack: CoreDataStack, movement: MovementServiceProtocol) {
        self.coreDataStack = coreDataStack
        self.movement = movement
    }
}
