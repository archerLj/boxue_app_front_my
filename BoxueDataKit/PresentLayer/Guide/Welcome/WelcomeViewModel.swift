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
    public var isiOS12OrLater: Bool = Flag.isiOS12OrLater
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
                // 这里因为.done是异步的，所以单元测试不能进行，就把.done里面的内容单独拿出来
                // 这样单元测试就只测试self.transmute()方法就可以了
                self.transmute(withPermissionNoteDetermined: $0)
        }
    }
    
    public func transmute(withPermissionNoteDetermined: Bool) {
        withPermissionNoteDetermined ? requestNotification() : browseDirectly()
    }
    
    public func requestNotification() {
        if isiOS12OrLater {
            requestProvisionalNotificationSubject.onNext(())
            browserResponder.browse()
        } else {
            navigateToRequestNotification.navigateToRequestNotification()
        }
    }
    
    public func browseDirectly() {
        self.browserResponder.browse()
    }
}
