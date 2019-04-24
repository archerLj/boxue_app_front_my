//
//  MainViewModelTests.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/23.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import BoxueDataKit

class MainViewModelTests: CommonTests {
    /// - TypeAlias
    typealias Expected = [Recorded<Event<MainViewStatus>>]
    
    /// - Methods
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// - Tests
    func testGuidingStatus() {
        let expected: Expected = [.next(0, .launching), .next(0, .guiding)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.mainViewModel.guide()
        }
    }
    
    func testBrowsingStatus() {
        let expected: Expected = [.next(0, .launching), .next(0, .browsing)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.mainViewModel.browse()
        }
    }
}
