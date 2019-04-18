//
//  RequestNotificationRootView.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import PromiseKit
import UserNotifications
import BoxueUIKit
import BoxueDataKit

class RequestNotificationRootView: NiblessView {
    
    /// - Properties
    let bag = DisposeBag()
    var viewNotReady = true
    let viewModel: NotificationViewModel
    
    /// - Methods
    public init(frame: CGRect = .zero, viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        bindInteraction()
    }
    
    let notificationBg: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "request-notification-bg"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let notificationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "notification-icon"))
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return imageView
    }()
    
    let enableTitle: UILabel = {
        let lable = UILabel()
        lable.text = .requestNotificationTitle
        lable.numberOfLines = 0
        lable.textColor = .white
        lable.textAlignment = .center
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        
        return lable
    }()
    
    let enableDesc: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Color.blueGreen
        label.text = .requestNotificationDesc
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        
        return label
    }()
    
    let enableButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        button.backgroundColor = SystemColor.blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle(.requestNotificationConfirm, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    let notNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Color.labelBtnYellow, for: .normal)
        button.setTitle(.requestNotificationNotNow, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [enableButton, notNowButton])
        sv.spacing = 15
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        return sv
    }()
    
    /// - Public methods
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard viewNotReady else {
            return
        }
        
        constructViewHierarchy()
        activateConstraints()
        
        viewNotReady = false
    }
    
    func constructViewHierarchy() {
        addSubview(notificationBg)
        addSubview(notificationIcon)
        addSubview(enableTitle)
        addSubview(enableDesc)
        addSubview(buttonStackView)
    }
    
    func activateConstraints() {
        activateConstraintsNotificationBg()
        activateConstraintsNotificationIcon()
        activateConstraintsEnableTitle()
        activateConstraintsEnableDesc()
        activateConstraintsButtonStack()
    }
    
    func activateConstraintsNotificationBg() {
        notificationBg.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationBg.topAnchor.constraint(equalTo: self.topAnchor),
            notificationBg.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            notificationBg.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            notificationBg.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    func activateConstraintsNotificationIcon() {
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            notificationIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 66)
            ])
    }
    
    func activateConstraintsEnableTitle() {
        enableTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            enableTitle.topAnchor.constraint(equalTo: notificationIcon.bottomAnchor, constant: 26),
            enableTitle.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            enableButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
            ])
    }
    
    func activateConstraintsEnableDesc() {
        enableDesc.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            enableDesc.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            enableButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            enableButton.bottomAnchor.constraint(equalTo: self.buttonStackView.topAnchor, constant: -20)
            ])
    }
    
    func activateConstraintsButtonStack() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -55)
            ])
    }
    
}


extension RequestNotificationRootView {
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge, .alert, .sound])
            .done {
                if $0 {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.viewModel.enableNotificationTapped()
                } else {
                    self.viewModel.disableNotificationTapped()
                }
            }.catch {
                fatalError($0.localizedDescription)
            }
    }
    
    func bindInteraction() {
        enableButton.rx.tap.bind {
            let center = UNUserNotificationCenter.current()
            
            center.isNotificationPermissionDenied()
                .done {
                    if $0 {
                        self.viewModel.disableNotificationBySystem()
                    } else {
                        self.requestNotificationAuthorization()
                    }
                }
        }.disposed(by: bag)
        
        notNowButton.rx.tap.bind {
            self.viewModel.noteDeterminedTapped()
        }.disposed(by: bag)
    }
}

extension String {
    static let requestNotificationTitle = localized(of: "REQ_NOTI_TITLE")
    static let requestNotificationDesc = localized(of: "REQ_NOTI_DESC")
    static let requestNotificationConfirm = localized(of: "REQ_NOTI_CONFIRM")
    static let requestNotificationNotNow = localized(of: "REQ_NOTI_NOTNOW")
}
