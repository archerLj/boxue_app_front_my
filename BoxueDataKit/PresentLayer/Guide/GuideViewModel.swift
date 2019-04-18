//
//  GuideViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift

public typealias GuideNavigateAction = NavigationAction<GuideViewStatus>

public class GuideViewModel:
    NavigateToSignIn,
    NavigateToSignUp,
    NavigateToContactUs,
    NavigateToResetPassword,
NavigateToRequestNotification {
    
    public init() {}
    
    private let viewBehavior = BehaviorSubject<GuideNavigateAction>(value: .present(viewStatus: .welcome))
    public var viewStatus: Observable<GuideNavigateAction> {
        return viewBehavior.asObservable()
    }
    
    public func navigateToSignIn() {
        viewBehavior.onNext(.present(viewStatus: .signIn))
    }
    
    public func navigateToSignUp() {
        viewBehavior.onNext(.present(viewStatus: .signUp))
    }
    
    public func navigateToContactUs() {
        viewBehavior.onNext(.present(viewStatus: .contactUs))
    }
    
    public func navigateToResetPassword() {
        viewBehavior.onNext(.present(viewStatus: .resetPassword))
    }
    
    public func navigateToRequestNotification() {
        viewBehavior.onNext(.present(viewStatus: .requestNotification))
    }
    
    public func presented(guideViewStatus: GuideViewStatus) {
        viewBehavior.onNext(.presented(viewStatus: guideViewStatus))
    }
}
