//
//  AppDelegate.swift
//  Boxue
//
//  Created by archerLj on 2019/4/3.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import Boxue_iOS

/**
 在OC的项目中还能看到main函数入口，可以看到main函数入口是一个UIApplicationMain方法，该方法会创建一个app实例UIApplication，并通过传入的AppDelegate类名实例化应用程序代理对象，并创建消息循环。
 我们可以在代码中通过UIApplication.share来获取到app实例，UIApplication对象和AppDelegate对象会一直存在app的生命周期中。当然，在swift项目中，main函数入口已经被隐藏了，AppDelegate也通过@UIApplicationMain注解来指定了.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let diContainer = BoxueAppDepedencyContainer()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = diContainer.makeMainViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        return true
    }
}

