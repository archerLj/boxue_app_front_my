//
//  WelcomeRootView.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import BoxueUIKit
import BoxueDataKit

public class WelcomeRootView: LaunchAndWelcomeView {
    /// - Properties
    let viewModel: WelcomeViewModel
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 6
        button.setTitle(.signIn, for: .normal)
        button.backgroundColor = SystemColor.blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    let browseNowButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(.browseNow, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitleColor(Color.labelBtnYellow, for: .normal)
        
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [signInButton, browseNowButton])
        
        sv.spacing = 15
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        return sv
    }()
    
    override func constructViewHierarchy() {
        super.constructViewHierarchy()
        addSubview(buttonStackView)
    }
    
    override func activateConstraints() {
        super.activateConstraints()
        activateConstraintsButtonStack()
    }
    
    func activateConstraintsButtonStack() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hCenter = buttonStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let leading = buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        let trailing = buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        let bottom = buttonStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        
        NSLayoutConstraint.activate([hCenter, leading, trailing, bottom])
    }
    
    /// - Methods
    init(frame: CGRect = .zero, viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    // Register
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        signInButton.addTarget(viewModel, action: #selector(WelcomeViewModel.showSignInView), for: .touchUpInside)
        browseNowButton.addTarget(viewModel, action: #selector(WelcomeViewModel.browseNowButtonTapped), for: .touchUpInside)
    }
}

extension String {
    static let signIn = localized(of: "SIGNIN")
    static let browseNow = localized(of: "BROWSE_NOW")
}
