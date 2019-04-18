//
//  RequestNotificationViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import BoxueUIKit
import BoxueDataKit
import RxSwift

public class RequestNotificationViewController: NiblessViewController {
    /// - Properties
    let viewModel: NotificationViewModel
    let bag = DisposeBag()
    
    public init(factory: NotificationViewModelFactory) {
        self.viewModel = factory.makeNotificationViewModel()
        super.init()
    }
    
    public override func loadView() {
        self.view = RequestNotificationRootView(viewModel: self.viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        observeDisableNotificationBySystem()
    }
    
    func observeDisableNotificationBySystem() {
        viewModel.systemDisablePermission
            .asDriver { _ in fatalError("Unexpected error from system disabled permission observable.") }
            .drive(onNext: { [weak self] errMessage in
                self?.presentSettingAlert(title: "Notification disabled",
                                          message: "You can enable the notification in Settings.",
                                          confirmButtonText: "OK",
                                          cancelButtonText: "Cancel",
                                          cancelHandler: { _ in self?.viewModel.disableNotificationTapped() })
            }).disposed(by: bag)
    }
}

public protocol NotificationViewModelFactory {
    func makeNotificationViewModel() -> NotificationViewModel
}
