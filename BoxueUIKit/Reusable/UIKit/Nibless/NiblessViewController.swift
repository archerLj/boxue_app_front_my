//
//  NiblessViewController.swift
//  BoxueUIKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit

open class NiblessViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // @available
    // 第一个参数表示指定的平台，比如iOS, MacOS, TVOS等
    // 第二个参数有unavailable: 表示在指定的平台上无效
    //           introduced: 表示从指定平台哪个版本开始才引入
    //           deprecated: 表示从指定平台的哪个版本开始弃用，虽然表示弃用，单仍然使用还是没有问题的
    //           obsoleted: 表示从指定平台的哪个版本开始废弃，废弃后就会从平台移除，不能再使用
    // 第三个参数是说明
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported.")
    }
}
