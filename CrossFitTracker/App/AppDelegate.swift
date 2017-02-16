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

    var presenting: UIViewController? {
        return navigationStack.peekAtStack()
    }

    fileprivate var navigationStack: [UIViewController] = []

    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack(modelName: "CrossFitTracker")
    }()

    lazy var movementService: MovementServiceProtocol = {
        return MovementService(coreDataStack: self.coreDataStack)
    }()

    lazy var services: ViewModelServicesProtocol = {
        return ViewModelServices(
            delegate: self,
            coreDataStack: self.coreDataStack,
            movement: self.movementService
        )
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Window, services, root VC
        window = UIWindow(frame: UIScreen.main.bounds)

        // Root view controller
        let vm = MovementTableViewModel(services: services)
        services.push(vm)

        let rootNavigationController = UINavigationController()
        navigationStack.push(rootNavigationController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}

// MARK: ViewModelServicesDelegate

extension AppDelegate: ViewModelServicesDelegate {

    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent) {
        DispatchQueue.main.async {
            switch navigate {
            case .Push(let vc, let style):
                switch style {
                case .Push:
                    if let top = self.presenting as? UINavigationController {
                        top.pushViewController(vc, animated: true)
                    }
                case .Modal:
                    if let top = self.presenting {
                        let navc = self.wrapNavigation(vc)
                        self.navigationStack.push(navc)
                        top.present(navc, animated: true, completion: nil)
                    }
                }
            case .Pop:
                if let navc = self.presenting as? UINavigationController {
                    if navc.viewControllers.count > 1 {
                        navc.popViewController(animated: true)
                    } else if self.navigationStack.count > 1 {
                        // There's only one VC in the navigation controller and we're not popping the root, so we must be looking at a modal. Pop the modal.
                        self.navigationStack.pop()?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    // Not a navigation controller at top of stack, so cannot be root.
                    self.navigationStack.pop()?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    private func wrapNavigation(_ vc: UIViewController) -> UINavigationController {
        let navc = UINavigationController(rootViewController: vc)
        navc.navigationBar.isTranslucent = false
        return navc
    }
}
