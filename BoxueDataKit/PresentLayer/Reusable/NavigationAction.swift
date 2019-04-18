//
//  NavigationAction.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public enum NavigationAction<ViewModelStatus>: Equatable where ViewModelStatus: Equatable {
    case present(viewStatus: ViewModelStatus)
    case presented(viewStatus: ViewModelStatus)
}
