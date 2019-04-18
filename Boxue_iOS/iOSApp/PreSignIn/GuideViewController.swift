//
//  GuideViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import BoxueUIKit
import BoxueDataKit

public class GuideViewController: NiblessNavigationController {
    /// - Properties
    let bag = DisposeBag()
    let viewModel: GuideViewModel
    
    let welcomeViewController: WelcomeViewController
    let signInViewController: SignInViewController
    let signUpViewController: SignUpViewController
    let contactUsViewController: ContactUsViewController
    let resetPasswordController: ResetPasswordViewController
    let requestNotificationViewController: RequestNotificationViewController
    
    /// - Methods
    init(viewModel: GuideViewModel,
         welcomeViewController: WelcomeViewController,
         signInViewController: SignInViewController,
         signUpViewController: SignUpViewController,
         contactUsViewController: ContactUsViewController,
         resetPasswordController: ResetPasswordViewController,
         requestNotificationViewController: RequestNotificationViewController) {
        
        self.viewModel = viewModel
        self.welcomeViewController = welcomeViewController
        self.signInViewController = signInViewController
        self.signUpViewController = signUpViewController
        self.contactUsViewController = contactUsViewController
        self.resetPasswordController = resetPasswordController
        self.requestNotificationViewController = requestNotificationViewController
        
        super.init()
        self.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.viewStatus)
    }
    
    func subscribe(to observable: Observable<GuideNavigateAction>) {
        observable.distinctUntilChanged()
            .subscribe(onNext: { [weak self] action in
                guard let `self` = self else { return }
                
                self.respond(to: action)
            }).disposed(by: bag)
    }
    
    func respond(to navigateAction: GuideNavigateAction) {
        switch navigateAction {
        case .present(let viewStatus):
            present(viewStatus)
        case .presented:
            break
        }
    }
    
    func present(_ viewStatus: GuideViewStatus) {
        switch viewStatus {
        case .welcome:
            self.presentWelcomeViewController()
        case .signIn:
            self.presentSignInViewController()
        case .signUp:
            self.presentSignUpViewController()
        case .contactUs:
            self.presentContactUsViewController()
        case .resetPassword:
            self.presentResetPasswordViewController()
        case .requestNotification:
            self.presentRequestNotificationViewController()
        }
    }
    
    func presentWelcomeViewController() {
        pushViewController(welcomeViewController, animated: true)
    }
    
    func presentSignInViewController() {
        pushViewController(signInViewController, animated: true)
    }
    
    func presentSignUpViewController() {
        pushViewController(signUpViewController, animated: true)
    }
    
    func presentContactUsViewController() {
        pushViewController(contactUsViewController, animated: true)
    }
    
    func presentResetPasswordViewController() {
        pushViewController(resetPasswordController, animated: true)
    }
    
    func presentRequestNotificationViewController() {
        pushViewController(requestNotificationViewController, animated: true)
    }
}

extension GuideViewController {
    func toggleNavigationBar(for view: GuideViewStatus, animated: Bool)  {
        if view.hideNavigationBar() {
            hideNavigationBar(animated: true)
        } else {
            showNavigationBar(animated: true)
        }
    }
    
    func hideNavigationBar(animated: Bool) {
        if animated {
            transitionCoordinator?.animate(alongsideTransition: { context in
                self.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
        } else {
            self.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func showNavigationBar(animated: Bool) {
        if animated {
            transitionCoordinator?.animate(alongsideTransition: { context in
                self.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        } else {
            self.setNavigationBarHidden(false, animated: false)
        }
    }
}

/// - UINavigationControllerDelegate
extension GuideViewController: UINavigationControllerDelegate {
    private func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let destView = guidingView(to: viewController) else {
            return
        }
        
        toggleNavigationBar(for: destView, animated: animated)
    }
    
    private func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let destView = guidingView(to: viewController) else {
            return
        }
        viewModel.presented(guideViewStatus: destView)
    }
}

extension GuideViewController {
    func guidingView(to viewController: UIViewController) -> GuideViewStatus? {
        switch viewController {
        case is WelcomeViewController:
            return .welcome
        case is SignInViewController:
            return .signIn
        case is SignUpViewController:
            return .signUp
        case is ContactUsViewController:
            return .contactUs
        case is ResetPasswordViewController:
            return .resetPassword
        case is RequestNotificationViewController:
            return .requestNotification
        default:
            assertionFailure("Invalid view controller is embedded in GuideViewController")
            return nil
        }
    }
}
