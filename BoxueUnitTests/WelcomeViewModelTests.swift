//
//  WelcomeViewModel.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/23.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import BoxueDataKit

class WelcomeViewModelTests: CommonTests {
    
    /// - Properties
    var welcomVM: WelcomeViewModel!
    var guideVM: GuideViewModel!

    override func setUp() {
        super.setUp()
        welcomVM = guideContainer.makeWelcomViewModel()
        guideVM = guideContainer.sharedGuideViewModel
    }

    override func tearDown() {
        welcomVM = nil
        guideVM = nil
        super.tearDown()
    }
    
    func testRequestProvisionalNotificationAndGoToBrowseAferiOS12() {
        welcomVM.isiOS12OrLater = true
        let expected: [Recorded<Event<MainViewStatus>>] = [.next(0, .launching), .next(0, .browsing)]
        
        t(source: mainViewModel.viewStatus, expected: expected, process: welcomVM.requestNotification)
        t_c(source: welcomVM.requestProvisionalNotification, expected: 1, process: welcomVM.requestNotification)
    }
    
    func testRequestNormalNotificationBeforeiOS12() {
        welcomVM.isiOS12OrLater = false
        let expected: [Recorded<Event<GuideNavigateAction>>] = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .requestNotification))]
        
        t(source: guideVM.viewStatus, expected: expected, process: welcomVM.requestNotification)
    }
    
    func testGotoBrowseDirectly() {
        let expected: [Recorded<Event<MainViewStatus>>] = [.next(0, .launching), .next(0, .browsing)]
        
        t(source: mainViewModel.viewStatus, expected: expected, process: welcomVM.browseDirectly)
    }
    
    func testShowSignInView() {
        let expected: [Recorded<Event<GuideNavigateAction>>] = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .signIn))]
        t(source: guideVM.viewStatus, expected: expected, process: welcomVM.showSignInView)
    }
    
    func testBrowseNowButtonTappedWhenPermissionNotDetermined() {
        welcomVM.isiOS12OrLater = true
        let expected: [Recorded<Event<MainViewStatus>>] = [.next(0, .launching), .next(0, .browsing)]
        
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.welcomVM.transmute(withPermissionNoteDetermined: true)
        }
        t_c(source: welcomVM.requestProvisionalNotification, expected: 1) {
            self.welcomVM.transmute(withPermissionNoteDetermined: true)
        }
    }
    
    func testBroweNowButtonTappedWhenPermissionDetermined() {
        let expected: [Recorded<Event<MainViewStatus>>] = [.next(0, .launching), .next(0, .browsing)]
        
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.welcomVM.transmute(withPermissionNoteDetermined: false)
        }
    }
}
