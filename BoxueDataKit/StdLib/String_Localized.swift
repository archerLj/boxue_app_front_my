//
//  String_Localized.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

extension String {
    public static func localized(of key: String, comment: String = "") -> String {
        return NSLocalizedString(key,
                                 tableName: "Localizable",
                                 bundle: Bundle.init(identifier: "com.techsun.zhonghua")!,
                                 comment: comment)
    }
}
