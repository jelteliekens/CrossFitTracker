//
//  CreateMovementViewController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

public class CreateMovementViewController: UITableViewController {

    @IBOutlet weak var movementTextField: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    public var viewModel: CreateMovementViewModel!

    public override func viewDidLoad() {
        saveButton.reactive.isEnabled <~ viewModel.create.isEnabled

        viewModel.movement <~ movementTextField
            .reactive
            .continuousTextValues
            .map { (movement) -> String in
                return movement ?? ""
            }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        movementTextField.becomeFirstResponder()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movementTextField.resignFirstResponder()
    }
}

// MARK: - IBActions

extension CreateMovementViewController {
    @IBAction func save(_ sender: UIBarButtonItem) {
        viewModel.create
            .apply(viewModel.movement.value)
            .start()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        viewModel.cancel
            .apply()
            .start()
    }
}
