//
//  UserSessionRepository.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {
    func readUserSession() -> Promise<UserSession>
    func signUp(newAccount: NewAccount) -> Promise<UserSession>
    func signIn(email: String, password: Secret) -> Promise<UserSession>
    func signOut() -> Promise<Bool>
    
    func isSignedIn() -> Guarantee<Bool>
}
