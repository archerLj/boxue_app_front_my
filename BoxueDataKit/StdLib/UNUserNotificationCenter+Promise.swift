//
//  UNUserNotificationCenter+Promise.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications
import PromiseKit

extension UNUserNotificationCenter {

    func getNotificationSettings() -> Guarantee<UNNotificationSettings> {
        
        // Guarantee<T>.init中closure的类型是((T) -> Void) -> Void
        // 而getNotificationSettings需要的参数是一个 (UNNotificationSettings) -> Void closure参数，所以
        // 我们直接把Guarantee<T>.init方法中的参数直接传递给getNotificationSettings就可以了
        
        // 这样，我们就可以使用Promise的方式来处理App当前的通知推送设置了
        return Guarantee<UNNotificationSettings> {
            getNotificationSettings(completionHandler: $0)
        }
    }
    
    public func isNotificationPermissionNotDetermined() -> Guarantee<Bool> {
        return firstly {
                getNotificationSettings()
            }.then { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    return Guarantee.value(true)
                default:
                    return Guarantee.value(false)
                }
            }
    }
    
    // PromiseKit中专门提供了一个类:Guarantee, 表示一个永远不会失败的承诺
    // 创建Guarantee直接使用value方法设置值就行了，不需要像Promise一样屌用reject和fullfill
    // 串联Guarantee的时候我们也无需掉用catch处理错误，因为不会产生错误.
    public func isNotificationPermissionAuthorized() -> Guarantee<Bool> {
        
        // Promise提供的几个wrappers
        // firstly只是一个语法糖，用来明确整个事件的起点，甚至可以不用，直接getNotificationSettings().then{ } 也可以
        // then和done是类似的，只是then返回Promise<T>, 后面还可以串联then或者done，而doen则表示Promise实现后最后要做的事，表示后续不会再有动作了，返回值是Promise<Void>
        
        // Garantee甚至提供了map，但是map只是简单的值转换，不会返回Promise<T>，如果只是单纯的转换期望值，用map，如果后续还要
        // 串联then，done等处理就用then
        return firstly {
                getNotificationSettings()
            }.then { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    return Guarantee.value(true)
                default:
                    return Guarantee.value(false)
                }
            }
    }
    
    public func isNotificationPermissionDenied() -> Guarantee<Bool> {
        return firstly {
                getNotificationSettings()
            }.then { settings in
                switch settings.authorizationStatus {
                case .denied:
                    return Guarantee.value(true)
                default:
                    return Guarantee.value(false)
                }
            }
    }
    
    public func requestAuthorization(options: UNAuthorizationOptions) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            // requestAuthorization completionHandler的方法签名(Bool, Error?) -> Void
            // resolver正好有一个签名相同的方法resolve，直接传递给原生方法就可以了，后面就可以用Promise的方式来
            // 处理用户的通知授权结果了
            requestAuthorization(options: options, completionHandler: resolver.resolve)
        }
    }
}
