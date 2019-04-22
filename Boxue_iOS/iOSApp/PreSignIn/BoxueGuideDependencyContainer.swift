//
//  BoxueGuideDependencyContainer.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import BoxueDataKit

public class BoxueGuideDependencyContainer {
    
    /// - Properties
    let sharedMainViewModel: MainViewModel
    let sharedUserSessionRepository: UserSessionRepository
    
    /// Long lived dependencies
    let sharedGuideViewModel: GuideViewModel
    
    public init(appDependencyContainer: BoxueAppDepedencyContainer) {
        func makeGuideViewModel() -> GuideViewModel {
            return GuideViewModel()
        }
        
        self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
        self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.sharedGuideViewModel = makeGuideViewModel()
    }
    
    public func makeGuideViewController() -> GuideViewController {
        return GuideViewController(viewModel: sharedGuideViewModel,
                                   welcomeViewController: makeWelcomeViewController(),
                                   signInViewController: makeSignInViewController(),
                                   signUpViewController: makeSignUpViewController(),
                                   contactUsViewController: makeContactUsViewController(),
                                   resetPasswordController: makeResetPasswordViewController(),
                                   requestNotificationViewController: makeRequestNotificationViewController())
    }
    
    public func makeWelcomeViewController() -> WelcomeViewController {
        return WelcomeViewController(welcomeViewModelFactory: self)
    }
    
    public func makeSignInViewController() -> SignInViewController {
        return SignInViewController(signInViewModelFactory: self)
    }
    
    public func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController()
    }
    
    public func makeContactUsViewController() -> ContactUsViewController {
        return ContactUsViewController()
    }
    
    public func makeResetPasswordViewController() -> ResetPasswordViewController {
        return ResetPasswordViewController()
    }
    
    public func makeRequestNotificationViewController() -> RequestNotificationViewController {
        return RequestNotificationViewController(factory: self)
    }
}


extension BoxueGuideDependencyContainer: WelcomeViewModelFactory {
    public func makeWelcomViewModel() -> WelcomeViewModel {
        return WelcomeViewModel(browserResponder: sharedMainViewModel,
                                navigateToSignIn: sharedGuideViewModel,
                                navigateToRequestNotification: sharedGuideViewModel)
    }
}

extension BoxueGuideDependencyContainer: SignInViewModelFactory {
    public func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(userSessionRepository: sharedUserSessionRepository,
                               browseResponder: sharedMainViewModel,
                               navigateToRequestNotification: sharedGuideViewModel)
    }
}

extension BoxueGuideDependencyContainer: NotificationViewModelFactory {
    public func makeNotificationViewModel() -> NotificationViewModel {
        return NotificationViewModel(browseResponder: sharedMainViewModel)
    }
}
