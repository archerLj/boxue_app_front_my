//
//  AuthRemoteAPI.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPI {
    func signIn(username: String, password: Secret) -> Promise<UserSession>
    func signUp(account: NewAccount) -> Promise<UserSession>
}
