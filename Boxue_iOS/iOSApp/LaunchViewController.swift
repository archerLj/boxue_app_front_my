//
//  LaunchViewController.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import BoxueDataKit
import BoxueUIKit

public class LaunchViewController: NiblessViewController {

    let viewModel: LaunchViewModel
    let bag: DisposeBag = DisposeBag()
    
    /// - Methods
    init(launchViewModelFactory: LaunchViewModelFactory) {
        self.viewModel = launchViewModelFactory.makeLaunchViewModel()
        super.init()
    }
    
    override public func loadView() {
        self.view = LaunchRootView(viewModel: viewModel)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        viewModel.gotoNextScreen()
    }
}

protocol LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel
}
