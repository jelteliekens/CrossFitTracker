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
        case Push, Modal
    }

    case Push(UIViewController, PushStyle)
    case Pop

    init(_ viewModel: ViewModelProtocol) {

        if let vm = viewModel as? MovementTableViewModel {
            self = .Push(MovementTableViewController(viewModel: vm), .Push)
//        } else if let vm = viewModel as? CreateTodoViewModel {
//            self = .Push(CreateTodoViewController(viewModel: vm), .Modal)
        } else {
            self = .Push(UIViewController(), .Push)
        }
    }
}
