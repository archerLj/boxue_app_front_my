//
//  GuideViewModelTests.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/23.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import BoxueDataKit

class GuideViewModelTests: CommonTests {

    /// - Typealias
    typealias Expected = [Recorded<Event<GuideNavigateAction>>]
    
    /// - Properties
    var guideVM: GuideViewModel!
    
    override func setUp() {
        super.setUp()
        guideVM = guideContainer.sharedGuideViewModel
    }

    override func tearDown() {
        guideVM = nil
        super.tearDown()
    }
    
    func testNavigateToSignIn() {
        let expected: Expected = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .signIn))]
        t(source: guideVM.viewStatus, expected: expected) {
            self.guideVM.navigateToSignIn()
        }
    }
    
    func testNavigateToSignUp() {
        let expected: Expected = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .signUp))]
        t(source: guideVM.viewStatus, expected: expected) {
            self.guideVM.navigateToSignUp()
        }
    }
    
    func testNavigateToContactUs() {
        let expected: Expected = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .contactUs))]
        t(source: guideVM.viewStatus, expected: expected) {
            self.guideVM.navigateToContactUs()
        }
    }
    
    func testNavigateToResetPassword() {
        let expected: Expected = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .resetPassword))]
        t(source: guideVM.viewStatus, expected: expected) {
            self.guideVM.navigateToResetPassword()
        }
    }
    
    func testNavigateToRequestNotification() {
        let expected: Expected = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .requestNotification))]
        t(source: guideVM.viewStatus, expected: expected) {
            self.guideVM.navigateToRequestNotification()
        }
    }
}
