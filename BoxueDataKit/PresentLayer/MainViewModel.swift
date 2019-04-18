//
//  MainViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/15.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift

public class MainViewModel: GuideResponder, BrowseResponder {
    /// - Properties
    public let viewSubject = BehaviorSubject<MainViewStatus>(value: .launching)
    public var viewStatus: Observable<MainViewStatus> {
        return viewSubject.asObservable()
    }
    
    /// - Methods
    public init() {}
    
    public func guide() {
        viewSubject.onNext(.guiding)
    }
    
    public func browse() {
        viewSubject.onNext(.browsing)
    }
}
