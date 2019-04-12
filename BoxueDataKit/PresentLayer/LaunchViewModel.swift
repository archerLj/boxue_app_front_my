//
//  LaunchViewModel.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift

public class LaunchViewModel {
    
    /// - Properties
    var isFirstLaunch = Flag.isFirstLaunch
    
    let userSessionRepository: UserSessionRepository
    let guideResponder: GuideResponder
    let browserResponder: BrowseResponder
    
    private let logMessagesSubject = PublishSubject<LogMessage>()
    public var logMessages: Observable<LogMessage> {
        return logMessagesSubject.asObservable()
    }
    
    /// - Initializers
    public init(userSessionRepository: UserSessionRepository,
                guideResponder: GuideResponder,
                browserResponder: BrowseResponder) {
        self.userSessionRepository = userSessionRepository
        self.guideResponder = guideResponder
        self.browserResponder = browserResponder
    }
    
    /// - Methods
    public func gotoNextScreen() {
        isFirstLaunch ? guideResponder.guide() : browserResponder.browse()
    }
}
