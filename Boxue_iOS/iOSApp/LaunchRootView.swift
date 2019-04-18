//
//  LaunchRootView.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/15.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import BoxueDataKit

class LaunchRootView: LaunchAndWelcomeView {
    
    /// - Properties
    let viewModel: LaunchViewModel
    
    /// - Initializers
    init(frame: CGRect = .zero, viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
}
