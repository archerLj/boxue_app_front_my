//
//  LaunchViewModelTests.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/23.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import BoxueDataKit

class LaunchViewModelTests: CommonTests {

    /// - Typealias
    typealias Expected = [Recorded<Event<MainViewStatus>>]
    
    /// - Properties
    var launchViewModel: LaunchViewModel!
    
    
    override func setUp() {
        super.setUp()
        launchViewModel = appContainer.makeLaunchViewModel()
    }

    override func tearDown() {
        launchViewModel = nil
        super.tearDown()
    }
    
    func testFirstLaunching() {
        let expected: Expected = [.next(0, .launching), .next(0, .guiding)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.launchViewModel.isFirstLaunch = true
            self.launchViewModel.gotoNextScreen()
        }
    }
}
