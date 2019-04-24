//
//  Flag.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications

final public class Flag {
    
    #if TEST
        public static let isFirstLaunch = true
    #else
        public static let isFirstLaunch = Flag(for: "io.boxue.Launch.wasLaunchedBefore").wasNotSet
    #endif
    
    #if TEST
        public static let isiOS12OrLater = false
    #else
    public static var isiOS12OrLater: Bool {
        if #available(iOS 12.0, *) {
            return true
        }
        return false
    }
    #endif
    
    
    /// - Typealias
    public typealias Getter = () -> Bool
    public typealias Setter = (Bool) -> Void
    
    /// - Attributes
    var wasSet: Bool
    public var wasNotSet: Bool {
        return !wasSet
    }
    
    /// - Initializers
    public init(getter: Getter, setter: Setter) {
        self.wasSet = getter()
        
        if !wasSet {
            setter(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults = UserDefaults.standard,
                     for key: String) {
        self.init(getter: { () -> Bool in
            return userDefaults.bool(forKey: key)
        }) {
            userDefaults.set($0, forKey: key)
        }
    }
}
