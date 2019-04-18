//
//  NotificationViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

public class NotificationViewModel {
    /// - Properties
    let browseResponder: BrowseResponder
    let systemDisablePermissionSubject = PublishSubject<Void>()
    public var systemDisablePermission: Observable<Void> {
        return systemDisablePermissionSubject.asObservable()
    }
    
    /// - Initializer
    public init(browseResponder: BrowseResponder) {
        self.browseResponder = browseResponder
    }
    
    /// - Methods
    public func enableNotificationTapped() {
        navigateToBrowser()
    }
    
    public func disableNotificationTapped() {
        navigateToBrowser()
    }
    
    public func noteDeterminedTapped() {
        navigateToBrowser()
    }
    
    public func disableNotificationBySystem() {
        systemDisablePermissionSubject.onNext(())
    }
    
    func navigateToBrowser() {
        browseResponder.browse()
    }
}
