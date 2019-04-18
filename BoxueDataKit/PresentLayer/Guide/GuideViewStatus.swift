//
//  GuideViewStatus.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public enum GuideViewStatus {
    case welcome
    case signIn
    case signUp
    case contactUs
    case resetPassword
    case requestNotification
    
    public func hideNavigationBar() -> Bool {
        switch self {
        case .welcome, .requestNotification:
            return true
        default:
            return false
        }
    }
}
