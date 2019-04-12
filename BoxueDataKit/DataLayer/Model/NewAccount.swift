//
//  NewAccount.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public struct NewAccount: Codable {
    
    /// - Properties
    public let name: String
    public let email: String
    public let mobile: String
    public let password: Secret
    
    /// - Methods
    init(name: String, email: String, mobile: String, password: Secret) {
        self.name = name
        self.email = email
        self.mobile = mobile
        self.password = password
    }
}
