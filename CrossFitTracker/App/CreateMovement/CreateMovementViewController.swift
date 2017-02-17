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

public class CreateMovementViewController: ReactiveViewController<CreateMovementViewModel>, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    private var tableView = UITableView(frame: CGRect.zero, style: .grouped)

    private var nameTextField = UITextField()

    private var saveButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!

    private var didSetupConstraints = false

    // MARK: - Initializers

    init(viewModel: CreateMovementViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)

        saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                     target: self,
                                     action: #selector(self.save))

        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                       target: self,
                                       action: #selector(self.cancel))

        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .none

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deinit Controller")
    }

    // MARK: - UIViewController

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
        title = "Create Movement"

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton

        saveButton.reactive.isEnabled <~ viewModel.create.isEnabled

        viewModel.name <~ nameTextField
            .reactive
            .continuousTextValues
            .map { (name) -> String in
                return name ?? ""
            }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        super.viewWillDisappear(animated)
    }

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.selectionStyle = .none
        cell.contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(cell.contentView).offset(8)
            make.right.equalTo(cell.contentView).offset(8)
            make.centerY.equalTo(cell.contentView)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @objc public func save() {
        viewModel.create
            .apply(viewModel.name.value)
            .start()
    }

    @objc public func cancel() {
        viewModel.cancel
            .apply()
            .start()
    }
}
