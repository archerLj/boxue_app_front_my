//
//  BoxueAppDepedencyContainer.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift
import BoxueDataKit

public class BoxueAppDepedencyContainer {
    let sharedMainViewModel: MainViewModel
    let sharedUserSessionRepository: BoxueUserSessionRepository
    
    public init() {
        func makeUserSessionStore() -> UserSessionStore {
            return FakeUserSessionStore(hasToken: false)
        }
        
        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }
        
        func makeUserSessionRepository() -> BoxueUserSessionRepository {
            return BoxueUserSessionRepository(userSessionStore: makeUserSessionStore(), authRemoteAPI: makeAuthRemoteAPI())
        }
        
        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedUserSessionRepository = makeUserSessionRepository()
    }
    
    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()
        let guideViewControllerFactory = {
            return self.makeGuideViewController()
        }
        let browseViewControllerFactory = {
            return self.makeBrowseViewController()
        }
        
        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  guideViewControllerFactory: guideViewControllerFactory,
                                  browseViewControllerFactory: browseViewControllerFactory)
    }
    
    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }
    
    public func makeGuideViewController() -> GuideViewController {
        let di = BoxueGuideDependencyContainer(appDependencyContainer: self)
        return di.makeGuideViewController()
    }
    
    /// - Sign In
    public func makeSigndeInDenpendencyContainer() -> BoxueSignedInDependencyContainer {
        return BoxueSignedInDependencyContainer(appDependencyContainer: self)
    }
    
    public func makeBrowseViewController() -> BrowseViewController {
        return makeSigndeInDenpendencyContainer().makeBrowseViewController()
    }
}

extension BoxueAppDepedencyContainer: LaunchViewModelFactory {
    public func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userSessionRepository: self.sharedUserSessionRepository,
                               guideResponder: self.sharedMainViewModel,
                               browserResponder: self.sharedMainViewModel)
    }
}
