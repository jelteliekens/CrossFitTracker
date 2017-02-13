//
//  MovementOverviewViewModel.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

public final class MovementOverviewViewModel: ViewModel {
    public let pagingList: PagingList

    public override init(services: ViewModelServicesProtocol) {
        pagingList = MovementFetchedResultController(managedContext: services.coreDataStack.managedContext)
        super.init(services: services)
    }
}
