//
//  BrowseViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/18.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public class BrowseViewModel {
    let userSessionRepository: UserSessionRepository
    
    public init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
    }
}
