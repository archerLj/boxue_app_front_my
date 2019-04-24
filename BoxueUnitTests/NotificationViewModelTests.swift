//
//  NotificationViewModelTests.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/24.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import Boxue_iOS
@testable import BoxueDataKit


class NotificationViewModelTests: CommonTests {

    /// - Typealias
    typealias Expected = [Recorded<Event<MainViewStatus>>]
    
    /// - Properties
    var notificationVM: NotificationViewModel!
    
    override func setUp() {
        super.setUp()
        notificationVM = guideContainer.makeNotificationViewModel()
    }

    override func tearDown() {
        notificationVM = nil
        super.tearDown()
    }
    
    func testEnableNotification() {
        let expected: Expected = [.next(0, .launching), .next(0, .browsing)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.notificationVM.enableNotificationTapped()
        }
    }
    
    func testDisableNotification() {
        let expected: Expected = [.next(0, .launching), .next(0, .browsing)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.notificationVM.disableNotificationTapped()
        }
    }
    
    func testRemindMeLater() {
        let expected: Expected = [.next(0, .launching), .next(0, .browsing)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.notificationVM.noteDeterminedTapped()
        }
    }
    
    func testDisableNotificationBySystem() {
        t_c(source: notificationVM.systemDisablePermission, expected: 1) {
            self.notificationVM.disableNotificationBySystem()
        }
    }
}
