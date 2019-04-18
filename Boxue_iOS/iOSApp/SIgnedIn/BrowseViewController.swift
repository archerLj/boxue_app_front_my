//
//  BrowseViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import BoxueUIKit
import BoxueDataKit

public class BrowseViewController: NiblessViewController {
    /// - Properties
    let viewModel: BrowseViewModel
    
    init(factory: BrowseViewModelFactory) {
        self.viewModel = factory.makeBrowseViewModel()
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SystemColor.tealBlue
    }
}

protocol BrowseViewModelFactory {
    func makeBrowseViewModel() -> BrowseViewModel
}
