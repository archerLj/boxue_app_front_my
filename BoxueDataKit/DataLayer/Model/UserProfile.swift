//
//  UserProfile.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public struct UserProfile: Codable, Equatable {
    
    public let name: String
    public let email: String
    public let mobile: String
    public let avatar: URL
    
    public init(name: String, email: String, mobile: String, avatar: URL) {
        self.name = name
        self.email = email
        self.mobile = mobile
        self.avatar = avatar
    }
}
