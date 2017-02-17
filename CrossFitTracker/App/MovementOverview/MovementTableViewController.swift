//
//  MovementOverviewViewController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 10/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

public final class MovementTableViewController: ReactiveViewController<MovementTableViewModel>, UITableViewDelegate, UITableViewDataSource {

    public let tableView = UITableView(frame: CGRect.zero, style: .plain)
    public var createTodoButton: UIBarButtonItem!

    private var didSetupConstraints = false

    public struct MovementTableIdentifier {
        static let MovementCell = "MovementCell"
        static let CreateMovement = "CreateMovement"
    }

    public init(viewModel: MovementTableViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)

        createTodoButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(self.createMovementButtonPressed))

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: MovementTableIdentifier.MovementCell)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

    override public func updateViewConstraints() {
        super.updateViewConstraints()

        if !didSetupConstraints {

            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }

            didSetupConstraints = true
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movements"
        navigationItem.rightBarButtonItem = createTodoButton

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

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pagingList.numberOfSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pagingList.numberOfItemsInSection(section: section)
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovementTableIdentifier.MovementCell, for: indexPath)

        let movement = viewModel.pagingList.object(at: indexPath)

        cell.textLabel!.text = movement.title
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movement = viewModel.pagingList.object(at: indexPath)
            viewModel.deleteMovement.apply(movement).start()
        }
    }

    public func createMovementButtonPressed() {
        viewModel.createMovement
            .apply()
            .start()
    }
}
