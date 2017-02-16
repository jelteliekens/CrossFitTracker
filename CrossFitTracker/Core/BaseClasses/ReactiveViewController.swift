//
//  ReactiveViewController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 16/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import UIKit

public class ReactiveViewController<ViewModel: ViewModelProtocol>: UIViewController {

    public let viewModel: ViewModel

    public init(viewModel: ViewModel, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(viewModel: ViewModel) {
        self.init(viewModel: viewModel, nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
