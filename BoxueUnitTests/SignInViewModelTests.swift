//
//  BoxueSignInViewModelTests.swift
//  BoxueSignInViewModelTests
//
//  Created by ArcherLj on 2019/4/22.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import Boxue_iOS
import BoxueDataKit

class SignInViewModelTests: CommonTests {
    
    typealias Expected = [Recorded<Event<Bool>>]
    var viewModel: SignInViewModel!
    var guidVM: GuideViewModel!
    
    // TestScheduler是一个特殊的scheduler，他负责把某某事件放到某某地方去处理。这样，我们可以用TestScheduler把事件
    // 都调度到录制程序中，这样，等交互完成后，只可以直接比对事件序列的所有值是否正确了

    override func setUp() {
        super.setUp()
        viewModel = guideContainer.makeSignInViewModel()
        guidVM = guideContainer.sharedGuideViewModel
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // 测试email和password输入框起始状态是否可用。
    // 即测试emailInputEnabled事件序列的第一个事件是否是true。
    // 借用RxBlocking可以很简单的访问到事件序列的第一个值
    
    // toBlocking()将Observable转换成BlockingObservable，这个BlockingObservable可以阻断当前线程，让我们用他提供的方法等待
    // 特定的事件发生。常用的方法有以下三个：
    //  toArray(): 把Observable<T>中发生的所有事件转换成一个[T]，这个只适用于有限序列， 这样我们就可以用数组的形式观察到Observable中的所有值
    // first(): 得到Observable的第一个事件值
    // last(): 得到Observable的最后一个事件值
    func testEmailAndPasswordTextFieldStartsAtEnabled() throws {
        XCTAssertEqual(
            try viewModel.emailInputEnabled.toBlocking().first(),
            true)
        XCTAssertEqual(
            try viewModel.passwordInputEnabled.toBlocking().first(),
            true)
    }
    
    func testSignInButtonStartsAtEnabled() throws {
        XCTAssertEqual(
            try viewModel.signInButtonEnabled.toBlocking().first(),
            true)
    }
    
    func testSignInActivityIndicatorStartsAtHides() throws {
        XCTAssertEqual(
            try viewModel.signInActivityIndicatorAnimating.toBlocking().first(),
            false)
    }
    
    // 测试登陆按钮点击后，Eamil输入框是否会变成不可用状态
    func testEmailTextFieldDisbledAfterSignInButtonPressed() {
//        // 1 创建一个事件的“收录装置”，这个收录装置的事件值类型和我们要测试的事件值类型（emailInputEnabled）是一致的。
//        let emailEnabledRecoder = scheduler.createObserver(Bool.self)
//        // 2 关联“收录装置”和原始事件序列，这样emailInputEnabled发生一个事件，emailEnabledRecoder就会收录一个事件了
//        viewModel.emailInputEnabled.bind(to: emailEnabledRecoder).disposed(by: disposeBag)
//        // 3 用createColdObservable触发要测试的流程，
//        // [.next(10, ())]是要生成的事件流，10是TestScheduler需要的计数器，这里给个整数就行了。
//        //                               ()是要放到signInButtonTapped中的事件
//        // 把它绑定到signInButtonTapped，这样[.next(10, ())]就会触发一个登陆按钮点击事件
//        scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.signInButtonTapped).disposed(by: disposeBag)
//        // 4 因为创建的是一个cold observable，这里用start()启动他
//        scheduler.start()
//        // 5 按照我们测试的流程, 点击登陆按钮后，email输入框的可用状态就会从可用变成禁用，emailInputEnabled中就会生成true/false
//        // 事件，这些事件被emailEnabledRecoder录制下来后就会变成[.next(0, true), .next(10, false)]这样的数组。
//        XCTAssertEqual(emailEnabledRecoder.events, [.next(0, true), .next(10, false)])
        
        let expected: Expected = [.next(0, true), .next(0, false)]
        t(source: viewModel.emailInputEnabled, expected: expected) {
            self.viewModel.signInButtonTapped.onNext(())
        }
    }
    
    func testPasswordTextFieldDisabledAfterSignInButtonPressed() {
//        let passwordEnabledRecoder = scheduler.createObserver(Bool.self)
//        viewModel.passwordInputEnabled.bind(to: passwordEnabledRecoder).disposed(by: disposeBag)
//        scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.signInButtonTapped).disposed(by: disposeBag)
//        scheduler.start()
//        XCTAssertEqual(passwordEnabledRecoder.events, [.next(0, true), .next(10, false)])
        
        let expected: Expected = [.next(0, true), .next(0, false)]
        t(source: viewModel.passwordInputEnabled, expected: expected) {
            self.viewModel.signInButtonTapped.onNext(())
        }
    }
    
    func testActivityIndicatorAnimatingdAfterSignInButtonTapped() {
        let expected: Expected = [.next(0, false), .next(0, true)]
        t(source: viewModel.signInActivityIndicatorAnimating, expected: expected) {
            self.viewModel.signInButtonTapped.onNext(())
        }
    }
    
    func testGeneratingErrorMessageAfterSignInError() {
        t_c(source: viewModel.errorMessage, expected: 1) {
            self.viewModel.indicateSigningIn()
            let err = ErrorMessage(title: "Test", description: "Test description")
            self.viewModel.indicateSignInError(err)
        }
    }
    
    // 测试登陆发生错误后，重置UI的逻辑，比如email输入框从初始可用，到登陆按钮点击后禁用，再到出错后恢复可用，以及password，
    // 登陆按钮，activityIndicator都有自己的事件序列
    func testRestoreUIStateAfterErrorOccured() {
//        let emailRecoder = scheduler.createObserver(Bool.self)
//        let passwordRecoder = scheduler.createObserver(Bool.self)
//        let signInButtonRecoder = scheduler.createObserver(Bool.self)
//        let activityIndicatorRecoder = scheduler.createObserver(Bool.self)
//
//        viewModel.emailInputEnabled.bind(to: emailRecoder).disposed(by: disposeBag)
//        viewModel.passwordInputEnabled.bind(to: passwordRecoder).disposed(by: disposeBag)
//        viewModel.signInButtonEnabled.bind(to: signInButtonRecoder).disposed(by: disposeBag)
//        viewModel.signInActivityIndicatorAnimating.bind(to: activityIndicatorRecoder).disposed(by: disposeBag)
//
//        // 这里我们直接订阅了这个“人工事件”，对于上一个测试，我们也可以直接订阅人工事件，手动调用SignInViewModel.signIn()方法
//        scheduler.createColdObservable([.next(10, ())]).subscribe(onNext: {
//            self.viewModel.indicateSigningIn()
//            let error = ErrorMessage(title: "Test", description: "Test description")
//            self.viewModel.indicateSignInError(error)
//        }).disposed(by: disposeBag)
//
//        scheduler.start()
//
//        XCTAssertEqual(emailRecoder.events, [.next(0, true), .next(10, false), .next(10, true)])
//        XCTAssertEqual(passwordRecoder.events, [.next(0, true), .next(10, false), .next(10, true)])
//        XCTAssertEqual(signInButtonRecoder.events, [.next(0, true), .next(10, false), .next(10, true)])
//        XCTAssertEqual(activityIndicatorRecoder.events, [.next(0, false), .next(10, true), .next(10, false)])
        
        let expected: Expected = [.next(0, true), .next(0, false), .next(0, true)]
        let indicatorExpected: Expected = [.next(0, false), .next(0, true), .next(0, false)]
        
        func trigger() {
            self.viewModel.indicateSigningIn()
            let err = ErrorMessage(title: "Test", description: "Test description")
            self.viewModel.indicateSignInError(err)
        }
        
        t(source: viewModel.emailInputEnabled, expected: expected, process: trigger)
        t(source: viewModel.passwordInputEnabled, expected: expected, process: trigger)
        t(source: viewModel.signInButtonEnabled, expected: expected, process: trigger)
        t(source: viewModel.signInActivityIndicatorAnimating, expected: indicatorExpected, process: trigger)
    }
    
    func testGetEmailAndPassword() {
        let email = "lj0011977@163.com"
        let password = "123456"
        
        viewModel.emailInput.onNext(email)
        viewModel.passwordInput.onNext(password)
        
        let (e, p) = viewModel.getEmailAndPassword()
        XCTAssertEqual(email, e)
        XCTAssertEqual(password, p)
    }
    
    func testSignInSuccessfullyWhenPermissionNotDetermined() {
        let expected: [Recorded<Event<GuideNavigateAction>>] = [.next(0, .present(viewStatus: .welcome)), .next(0, .present(viewStatus: .requestNotification))]
        t(source: guidVM.viewStatus, expected: expected) {
            self.viewModel.transmute(withPermissionNotDetermined: true)
        }
    }
    
    func testSignInSUccessfullyWhenPermissionDetermined() {
        let expected: [Recorded<Event<MainViewStatus>>] = [.next(0, .launching), .next(0, .browsing)]
        t(source: mainViewModel.viewStatus, expected: expected) {
            self.viewModel.transmute(withPermissionNotDetermined: false)
        }
    }
}
