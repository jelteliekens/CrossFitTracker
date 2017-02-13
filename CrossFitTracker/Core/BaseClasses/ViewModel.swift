//
//  ViewModel.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 11/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

public class ViewModel: ViewModelProtocol {

    public let services: ViewModelServicesProtocol

    public init(services: ViewModelServicesProtocol) {
        self.services = services
    }
}
