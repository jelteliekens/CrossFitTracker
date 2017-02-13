//
//  MovementOverviewViewController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import UIKit
import ReactiveSwift

public final class MovementOverviewViewController: UITableViewController {

    public var viewModel: MovementOverviewViewModel!

    public struct MovementOverviewIdentifier {
        static let MovementCell = "MovementCell"
        static let CreateMovement = "CreateMovement"
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.pagingList.changes
            .observe(on: UIScheduler())
            .observeValues { (changes) in
                self.tableView.beginUpdates()

                for change in changes {
                    switch change {
                    case .insert(let indexPath):
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    case .delete(let indexPath):
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .update(let indexPath):
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    case .move(let oldIndexPath, let newIndexPath):
                        self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
                    }
                }

                self.tableView.endUpdates()
        }
    }
}

extension MovementOverviewViewController {
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovementOverviewIdentifier.MovementCell, for: indexPath)
        cell.textLabel!.text = "Hallo"
        return cell
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pagingList.numberOfSections()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pagingList.numberOfItemsInSection(section: section)
    }
}

// MARK: - Segue
extension MovementOverviewViewController {
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == MovementOverviewIdentifier.CreateMovement,
            let navController = segue.destination as? UINavigationController,
            let createMovementViewController =
                navController.topViewController as? CreateMovementViewController else {
            return
        }

        createMovementViewController.viewModel = CreateMovemenViewModel(services: viewModel.services)
    }
}
