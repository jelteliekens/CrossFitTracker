//
//  AppDelegate.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 19/12/2016.
//  Copyright © 2016 Jelte Liekens. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack(modelName: "CrossFitTracker")
    }()

    lazy var movementService: MovementServiceProtocol = {
        return MovementService(coreDataStack: self.coreDataStack)
    }()

    lazy var services: ViewModelServicesProtocol = {
        return ViewModelServices(
            coreDataStack: self.coreDataStack,
            movement: self.movementService
        )
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        guard let window = window,
            let navController = window.rootViewController as? UINavigationController,
            let movementOverviewViewController = navController.topViewController as? MovementOverviewViewController else {
            return false
        }

        movementOverviewViewController.viewModel = MovementOverviewViewModel(services: services)

        return true
    }
}
