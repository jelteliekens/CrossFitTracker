//
//  NavigationEvent.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 16/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import UIKit

public enum NavigationEvent {

    public enum PushStyle {
        case push, modal
    }

    case push(UIViewController, PushStyle)
    case pop

    init(_ viewModel: ViewModelProtocol) {
        if let vm = viewModel as? MovementTableViewModel {
            self = .push(MovementTableViewController(viewModel: vm), .push)
        } else if let vm = viewModel as? CreateMovementViewModel {
            self = .push(CreateMovementViewController(viewModel: vm), .modal)
        } else {
            self = .push(UIViewController(), .push)
        }
    }
}
