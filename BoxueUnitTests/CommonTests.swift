//
//  CommonTests.swift
//  BoxueUnitTests
//
//  Created by ArcherLj on 2019/4/23.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Foundation

@testable import Boxue_iOS
@testable import BoxueDataKit

class CommonTests: XCTestCase {
    
    // Criterial<T> 是 XCTAserrtEqual的一个签名(RxText中)，T表示Observable中事件值的类型,
    // 前两个参数分别表示期望的和收录到的事件数组，
    // 第三个参数表示测试所在的文件名,
    // 第四个参数表示测试断言所在的行号，这两个都有默认值，分别是#file和#line
    typealias Criteria<T> = ([Recorded<Event<T>>], [Recorded<Event<T>>], StaticString, UInt) -> Void
    
    /// - Properties
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    /// - Containers
    var appContainer: BoxueAppDepedencyContainer!
    var guideContainer: BoxueGuideDependencyContainer!
    
    /// - Models
    var mainViewModel: MainViewModel!
    
    ///- Methods
    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        appContainer = BoxueAppDepedencyContainer()
        guideContainer = BoxueGuideDependencyContainer(appDependencyContainer: appContainer)
        mainViewModel = appContainer.sharedMainViewModel
    }
    
    override func tearDown() {
        appContainer = nil
        guideContainer = nil
        mainViewModel = nil
    }
    
    // 比较事件录制结果和期望结果的模版
    /**
     * source: 要测试的Observable
     * expected: 期望的结果
     * process: 测试过程
     */
    func t<T: Equatable>(source: Observable<T>,
                         expected: [Recorded<Event<T>>],
                         process: @escaping() -> Void) {
        let recorder = scheduler.createObserver(T.self)
        source.bind(to: recorder).disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, ())])
            .subscribe(onNext: {
                process()
            }).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(recorder.events, expected)
    }
    
    // 比较录制到的事件个数的模版
    func t_c<T>(source: Observable<T>,
                expected: Int,
                process: @escaping () -> Void) {
        let recoder = scheduler.createObserver(T.self)
        source.bind(to: recoder).disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, ())])
            .subscribe(onNext: {
                process()
            }).disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(recoder.events.count, expected)
    }
}
