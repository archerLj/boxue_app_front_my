//
//  SignInViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

public class SignInViewModel {
    
    /// - Properties
    let userSessionRepository: UserSessionRepository
    let browseResponder: BrowseResponder
    let navigateToRequestNotification: NavigateToRequestNotification
    
    public let signInButtonTapped = PublishSubject<Void>()
    public let emailInput = BehaviorSubject<String>(value: "")
    public let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    public let passwordInput = BehaviorSubject<String>(value: "")
    public let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    public let signInButtonEnabled = BehaviorSubject<Bool>(value: true)
    public let signInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    public let err = ErrorMessage(title: .signInErrorTitle, description: .signInErrorDesc)
    private let errorMessageSubject = PublishSubject<ErrorMessage>()
    public var errorMessage: Observable<ErrorMessage> {
        return errorMessageSubject.asObservable()
    }
    
    public let bag = DisposeBag()
    
    /// - Init Methods
    public init (userSessionRepository: UserSessionRepository,
                 browseResponder: BrowseResponder,
                 navigateToRequestNotification: NavigateToRequestNotification) {
        
        self.userSessionRepository = userSessionRepository
        self.browseResponder = browseResponder
        self.navigateToRequestNotification = navigateToRequestNotification
        
        signInButtonTapped.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.signIn()
        }).disposed(by: bag)
    }
    
    
    /// - Other methods
    func indicateSigningIn() {
        emailInputEnabled.onNext(false)
        passwordInputEnabled.onNext(false)
        signInButtonEnabled.onNext(false)
        signInActivityIndicatorAnimating.onNext(true)
    }
    
    func indicateSignInError(_ error: Error) {
        errorMessageSubject.onNext(err)
        emailInputEnabled.onNext(true)
        passwordInputEnabled.onNext(true)
        signInButtonEnabled.onNext(true)
        signInActivityIndicatorAnimating.onNext(false)
    }
    
    func getEmailAndPassword() -> (String, Secret) {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            return (email, password)
        } catch {
            fatalError("Failed to reading email and password from subject behavior.")
        }
    }
    
    func navigateToNotification() {
        self.navigateToRequestNotification.navigateToRequestNotification()
    }
    
    func navigateToBrowse() {
        self.browseResponder.browse()
    }
    
    @objc public func signIn() {
        indicateSigningIn()
        let (email, password) = getEmailAndPassword()
        userSessionRepository.signIn(email: email, password: password)
            .then { _ in
                UNUserNotificationCenter.current().isNotificationPermissionNotDetermined()
            }.done {
                self.transmute(withPermissionNotDetermined: $0)
            }.catch(self.indicateSignInError)
    }
    
    func transmute(withPermissionNotDetermined: Bool) {
        withPermissionNotDetermined ? navigateToNotification() : navigateToBrowse()
    }
}

extension String {
    static let signInErrorTitle = localized(of: "SIGN_IN_ERROR_TITLE")
    static let signInErrorDesc = localized(of: "SIGN_IN_ERROR_DESC")
}
