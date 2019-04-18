//
//  BoxueSignedInDependencyContainer.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/18.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import BoxueUIKit
import BoxueDataKit

public class BoxueSignedInDependencyContainer {
    /// - Properties
    let sharedUserSessionRepository: UserSessionRepository
    
    /// - Methods
    public init(appDependencyContainer: BoxueAppDepedencyContainer) {
        self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
    }
    
    public func makeBrowseViewController() -> BrowseViewController {
        return BrowseViewController(factory: self)
    }
}

extension BoxueSignedInDependencyContainer: BrowseViewModelFactory {
    func makeBrowseViewModel() -> BrowseViewModel {
        return BrowseViewModel(userSessionRepository: sharedUserSessionRepository)
    }
}
