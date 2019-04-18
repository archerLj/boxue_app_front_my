//
//  WelcomeViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import PromiseKit

public class WelcomeViewModel {
    /// - Properties
    var isiOS12OrLater: Bool = Flag.isiOS12OrLater
    lazy var isNotificationPermissionNotDetermined = UNUserNotificationCenter.current().isNotificationPermissionNotDetermined()
    
    let browserResponder: BrowseResponder
    public let navigateToSignIn: NavigateToSignIn
    public let navigateToRequestNotification: NavigateToRequestNotification
    
    /// Only used after iOS 12
    let requestProvisionalNotificationSubject = PublishSubject<Void>()
    public var requestProvisionalNotification: Observable<Void> {
        return requestProvisionalNotificationSubject.asObservable()
    }
    
    /// - Methods
    public init(browserResponder: BrowseResponder,
                navigateToSignIn: NavigateToSignIn,
                navigateToRequestNotification: NavigateToRequestNotification) {
        self.browserResponder = browserResponder
        self.navigateToSignIn = navigateToSignIn
        self.navigateToRequestNotification = navigateToRequestNotification
    }
    
    @objc public func showSignInView() {
        navigateToSignIn.navigateToSignIn()
    }
    
    @objc public func browseNowButtonTapped() {
        firstly {
            UNUserNotificationCenter.current().isNotificationPermissionNotDetermined()
            }.done {
                self.transmute(withPermissionNoteDetermined: $0)
        }
    }
    
    func transmute(withPermissionNoteDetermined: Bool) {
        withPermissionNoteDetermined ? requestNotification() : browseDirectly()
    }
    
    func requestNotification() {
        if isiOS12OrLater {
            requestProvisionalNotificationSubject.onNext(())
            browserResponder.browse()
        } else {
            navigateToRequestNotification.navigateToRequestNotification()
        }
    }
    
    func browseDirectly() {
        
    }
}
