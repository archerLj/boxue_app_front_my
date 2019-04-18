//
//  WelcomeViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import BoxueUIKit
import RxSwift
import BoxueDataKit
import UserNotifications
import RxCocoa

public class WelcomeViewController: NiblessViewController {
    /// - Properties
    let bag = DisposeBag()
    let welcomeViewModelFactory: WelcomeViewModelFactory
    
    /// - Methods
    init(welcomeViewModelFactory: WelcomeViewModelFactory) {
        self.welcomeViewModelFactory = welcomeViewModelFactory
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
    }
    
    public override func loadView() {
        let vm = welcomeViewModelFactory.makeWelcomViewModel()
        view = WelcomeRootView(viewModel: vm)
        
        vm.requestProvisionalNotification
            .asDriver { _ in fatalError("Unexpected error from request provisional notification.") }
            .drive(onNext: self.requestProvisionalAuthorization)
            .disposed(by: bag)
    }
    
    func requestProvisionalAuthorization() {
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.badge, .alert, .sound, .provisional])
                .catch { fatalError($0.localizedDescription) }
        } else {
            UNUserNotificationCenter.current()
            .requestAuthorization(options: [.badge, .alert, .sound])
                .catch { fatalError($0.localizedDescription) }
        }
    }
}

protocol WelcomeViewModelFactory {
    func makeWelcomViewModel() -> WelcomeViewModel
}
