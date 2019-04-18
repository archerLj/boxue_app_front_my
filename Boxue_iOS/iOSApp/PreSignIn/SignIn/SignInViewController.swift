//
//  SignInViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import BoxueUIKit
import BoxueDataKit

public class SignInViewController: NiblessViewController {
    
    /// - Properties
    let viewModel: SignInViewModel
    let bag = DisposeBag()
    
    /// - Life Methods
    init(signInViewModelFactory: SignInViewModelFactory) {
        self.viewModel = signInViewModelFactory.makeSignInViewModel()
        super.init()
    }
    
    public override func loadView() {
        self.view = SignInRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .signIn
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    /// - Error handling
    func observeErrorMessage() {
        viewModel.errorMessage
            .asDriver { _ in fatalError("Unexpected error from error message observable.") }
            .drive(onNext: { [weak self] errorMsg in
                self?.present(errorMessage: errorMsg)
            }).disposed(by: bag)
    }
    
    
    /// - Respond to keyboard up and down
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustUIWithKeyBoard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustUIWithKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func adjustUIWithKeyBoard(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let covertedKeyboardFrame = view.convert(keyboardFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as! SignInRootView).resetScrollViewContenInsect()
            } else if (notification.name == UIResponder.keyboardWillShowNotification) {
                (view as! SignInRootView).moveContenForKeyboardDisplay(keyboardFrame: covertedKeyboardFrame)
            }
        }
    }
}

protocol SignInViewModelFactory {
    func makeSignInViewModel() -> SignInViewModel
}
