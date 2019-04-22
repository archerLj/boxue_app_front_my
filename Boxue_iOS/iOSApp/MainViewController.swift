//
//  MainViewController.swift
//  Boxue_iOS
//
//  Created by ArcherLj on 2019/4/15.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import BoxueUIKit
import BoxueDataKit

public class MainViewController: NiblessViewController {
    
    /// - Properties
    /// View Model
    let viewModel: MainViewModel
    
    /// Transition
    let dissolveTransitions: DissolveAnimator
    
    /// Child View Controllers
    let launchViewController: LaunchViewController
    var guideViewController: GuideViewController?
    var browseViewController: BrowseViewController?
    
    /// State
    let isFirstLaunch = Flag.isFirstLaunch
    let disposeBag = DisposeBag()
    
    /// Factories
    let makeGuideViewController: () -> GuideViewController
    let makeBrowseViewController: () -> BrowseViewController
    
    /// - Methods
    public init(viewModel: MainViewModel,
                launchViewController: LaunchViewController,
                guideViewControllerFactory: @escaping () -> GuideViewController,
                browseViewControllerFactory: @escaping () -> BrowseViewController) {
        
        self.dissolveTransitions = DissolveAnimator()
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        self.makeGuideViewController = guideViewControllerFactory
        self.makeBrowseViewController = browseViewControllerFactory
        
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func loadView() {
        self.view = MainRootView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        observerViewModel()
        super.viewDidAppear(animated)
    }
    
    private func observerViewModel() {
        let observable = self.viewModel.viewStatus.distinctUntilChanged()
        subscribe(to: observable)
    }
    
    func subscribe(to observable: Observable<MainViewStatus>) {
        observable.subscribe(onNext: {
            [weak self] status in
            guard let `self` = self else { return }
            self.present(status)
        }).disposed(by: disposeBag)
    }
    
    public func present(_ viewStatus: MainViewStatus) {
        switch viewStatus {
        case .launching:
            presentLaunching()
        case .guiding:
            presentGuiding()
        case .browsing:
            presentBrowsing()
        }
    }
    
    public func presentLaunching() {
        addFullScreen(childViewController: self.launchViewController)
    }
    
    public func presentGuiding() {
        let guideViewController = self.makeGuideViewController()
        guideViewController.transitioningDelegate = self
        
        present(guideViewController, animated: true) {
            [weak self] in
            guard let `self` = self else { return }
            
            self.remove(childViewController: self.launchViewController)
        }
        
        self.guideViewController = guideViewController
    }
    
    public func presentBrowsing() {
        remove(childViewController: launchViewController)
        
        let browseViewControllerPresent: BrowseViewController
        
        if let vc = self.browseViewController {
            browseViewControllerPresent = vc
        } else {
            browseViewControllerPresent  = makeBrowseViewController()
            self.browseViewController = browseViewControllerPresent
        }
        
        addFullScreen(childViewController: browseViewControllerPresent)
        // presentingViewController
        if guideViewController?.presentingViewController != nil {
            guideViewController = nil
            // dismiss
            dismiss(animated: true)
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dissolveTransitions
    }
}

class GenericError: Error {
}
