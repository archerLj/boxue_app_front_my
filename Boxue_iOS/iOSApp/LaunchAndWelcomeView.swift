//
//  LaunchAndWelcomeView.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import BoxueUIKit

public class LaunchAndWelcomeView: NiblessView {
    /// - Constants
    static let APP_TITLE_WIDTH: CGFloat = 300.0
    static let APP_TITLE_HEIGHT: CGFloat = 90.0
    
    /// - Properties
    var viewNotReady = true
    
    let bgImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchScreen_iPhoneX_dark"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.background
        return imageView
    }()
    
    let appTitleView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: LaunchAndWelcomeView.APP_TITLE_WIDTH, height: LaunchAndWelcomeView.APP_TITLE_HEIGHT)
        let view = UIView(frame: frame)
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [
            Color.appTitleGradientBegin.cgColor,
            Color.appTitleGradientMid.cgColor,
            Color.appTitleGradientEnd.cgColor
        ]
        view.layer.addSublayer(gradient)

        let label = UILabel(frame: view.bounds)
        label.text = .appTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        
        view.addSubview(label)
        view.mask = label
        
        return view
    }()
    
    let appSlogan: UILabel = {
        let label = UILabel()
        label.text = .appSlogan
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        
        return label
    }()
    
    let rightsInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = .rightsInfo
        label.textAlignment = .center
        label.textColor = Color.lightGray3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
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
    
    /// - Internal methods
    func constructViewHierarchy() {
        addSubview(bgImage)
        addSubview(appTitleView)
        addSubview(appSlogan)
        addSubview(rightsInfo)
    }
    
    func activateConstraints() {
        activateConstraintsBGImage()
        activateConstraintsAppTitle()
        activateConstraintsAppSlogan()
        activateConstraintsRightsInfo()
    }
    
    func activateConstraintsBGImage() {
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        
        let top = bgImage.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = bgImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = bgImage.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = bgImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
    
    func activateConstraintsAppTitle() {
        appTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        let hCenter = appTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let top = appTitleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140)
        let width = appTitleView.widthAnchor
    }
    
    func activateConstraintsAppSlogan() {
        
    }
    
    func activateConstraintsRightsInfo() {
        
    }
}


extension String {
    static let appTitle = localized(of: "APP_TITLE")
    static let appSlogan = localized(of: "APP_SLOGAN")
    static let rightsInfo = localized(of: "RIGHTS_INFO")
}
