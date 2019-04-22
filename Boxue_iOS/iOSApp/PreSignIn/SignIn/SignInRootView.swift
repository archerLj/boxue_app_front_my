//
//  SignInRootView.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BoxueUIKit
import BoxueDataKit

class SignInRootView: NiblessView {
    
    /// - Properties
    var viewNotReady = true
    let bag = DisposeBag()
    let viewModel: SignInViewModel
    
    /// - SubViews
    let contentView = UIView()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    let welcomeLabel: UILabel = {
        let lable = UILabel()
        lable.text = .welcomeLabel
        lable.numberOfLines = 0
        lable.textColor = .black
        lable.textAlignment = .center
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        
        return lable
    }()
    
    let emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.image = #imageLiteral(resourceName: "mail")
        imageView.contentMode = .center
        
        return imageView
    }()
    
    let emailInput: UITextField = {
        let input = UITextField()
        input.placeholder = .email
        input.textColor = .gray
        input.keyboardType = .emailAddress
        input.autocapitalizationType = .none // 首字母是否大写
        input.autocorrectionType = .no // 关闭自动纠错
        
        return input
    }()
    
    lazy var emailFiledStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailIcon, emailInput])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return stack
    }()
    
    let passwordIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.image = #imageLiteral(resourceName: "password")
        imageView.contentMode = .center
        
        return imageView
    }()
    
    let passwordInput: UITextField = {
        let input = UITextField()
        input.placeholder = .password
        input.isSecureTextEntry = true
        input.textColor = .gray
        input.heightAnchor.constraint(equalToConstant: 44)
        
        return input
    }()
    
    lazy var passwordFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordIcon, passwordInput])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return stack
    }()
    
    lazy var midSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = Color.separatorGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    lazy var signInFormStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailFiledStack, midSeparator, passwordFieldStack])
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        button.setTitle(.signIn, for: .normal)
        button.setTitle("", for: .disabled)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = SystemColor.blue
        
        return button
    }()
    
    let signInActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    let contactUsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.contactUs, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return button
    }()
    
    let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.resetPassword, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return button
    }()
    
    lazy var helpButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contactUsButton, resetPasswordButton])
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    let rightsInfo: UILabel = {
        let label = UILabel()
        label.text = .rightsInfo
        label.numberOfLines = 0
        label.textColor = Color.lightGray3
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        return label
    }()
    
    /// - Methods
    public init(frame: CGRect = .zero, viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        bindInteraction()
        bindTextInputsToViewModel()
        bindViewModelToViews()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard viewNotReady else { return }
        
        backgroundColor = .white
        constructViewHierarchy()
        activateConstraints()
        
        viewNotReady = false
    }
    
    func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(signInFormStack)
        contentView.addSubview(signInButton)
        contentView.addSubview(helpButtonStack)
        contentView.addSubview(rightsInfo)
        contentView.addSubview(signInActivityIndicator)
        
        addSubview(scrollView)
    }
    
    func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsWelcomeLabel()
        activateConstraintsSignInFormStack()
        activateConstraintsSignInButton()
        activateConstraintsSignInActivityIndicator()
        activateConstraintsHelpButtonStack()
        activateConstraintsRightsInfo()
    }
    
    func resetScrollViewContenInsect() {
        scrollView.contentInset = .zero
    }
    
    // 通过设置scrollView的contentInset属性，将scrollView下部留出一个键盘高度的空白
    // 这样scrollView的可滚动区域就会多了。
    func moveContenForKeyboardDisplay(keyboardFrame: CGRect) {
        scrollView.contentInset.bottom = keyboardFrame.height
    }
}

/// - Layouts
extension SignInRootView {
    func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }
    
    func activateConstraintsContentView() {
        // 设置contentView的关键是要确定scrollView的contentsize.
        // iOS 11之后，crollview多了contentLayoutGuide属性，只要将contentView的四个约束点固定在contentLayoutGuide的
        // 四个点上，scrollView就能自动计算contentSize了。contentView的宽高就要另行计算了。下面这里直接将宽高和scrollView
        // 一样了，暂时就不能滚动了.只要确定了contentView的宽高或者下右两边的约束，并把他约束到contentLayoutGuide的
        // 四个点上就能正常滚动了
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let svCLG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            contentView.topAnchor.constraint(equalTo: svCLG.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: svCLG.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: svCLG.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: svCLG.trailingAnchor)
            ])
        
        // iOS 11后，多了一个contentInsertAdjustmentBehavior属性，scrollView知道父试图的safe area，他会自动将
        // 子试图放置在safe area内，比如iPhoneX，即使scrollView起始点在刘海下面，他的滚动内容还是会把刘海空出来。当然
        // 如果把这个属性设置成.never，滚动内容就会覆盖刘海区域了
//        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func activateConstraintsWelcomeLabel() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 58),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }
    
    func activateConstraintsSignInFormStack() {
        signInFormStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInFormStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 58),
            signInFormStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signInFormStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }
    
    func activateConstraintsSignInButton() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: signInFormStack.bottomAnchor, constant: 25),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func activateConstraintsSignInActivityIndicator() {
        signInActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInActivityIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            signInActivityIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor)
            ])
    }
    
    func activateConstraintsHelpButtonStack() {
        helpButtonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            helpButtonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            helpButtonStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            helpButtonStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            helpButtonStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -55)
            ])
    }
    
    func activateConstraintsRightsInfo() {
        rightsInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightsInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            rightsInfo.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            rightsInfo.widthAnchor.constraint(equalToConstant: LaunchRootView.APP_TITLE_WIDTH)
            ])
    }
}

/// - UI Bind
extension SignInRootView {
    func bindInteraction() {
        signInButton.rx.tap
            .bind(to: viewModel.signInButtonTapped)
            .disposed(by: bag)
    }
    
    func bindTextInputsToViewModel() {
        bindEmailInput()
        bindPasswordInput()
    }
    
    func bindViewModelToViews() {
        bindViewModelToEmailField()
        bindViewModelToPasswordField()
        bindViewModelToSignInButton()
        bindViewModelToSignInActivityIndicator()
    }
    
    func bindEmailInput() {
        emailInput.rx.text
            .asDriver()
            .map { $0 ?? ""}
            .drive(viewModel.emailInput)
            .disposed(by: bag)
    }
    
    func bindPasswordInput() {
        passwordInput.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.passwordInput)
            .disposed(by: bag)
    }
    
    func bindViewModelToEmailField() {
        viewModel.emailInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(emailInput.rx.isEnabled)
            .disposed(by: bag)
    }
    
    func bindViewModelToPasswordField() {
        viewModel.passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passwordInput.rx.isEnabled)
            .disposed(by: bag)
    }
    
    func bindViewModelToSignInButton() {
        viewModel.signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(signInButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
    func bindViewModelToSignInActivityIndicator() {
        viewModel.signInActivityIndicatorAnimating
            .asDriver(onErrorJustReturn: true)
            .drive(signInActivityIndicator.rx.isAnimating)
            .disposed(by: bag)
    }
}


extension String {
    static let email = localized(of: "EMAIL")
    static let password = localized(of: "PASSWORD")
    static let contactUs = localized(of: "CONTACT_US")
    static let welcomeLabel = localized(of: "WELCOME_LABEL")
    static let resetPassword = localized(of: "RESET_PASSWORD")
}
