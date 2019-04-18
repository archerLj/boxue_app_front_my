//
//  BoxueUserSessionRepository.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public class BoxueUserSessionRepository: UserSessionRepository {
    
    /// - Properties
    let userSessionStore: UserSessionStore
    let authRemoteAPI: AuthRemoteAPI
    
    public init(userSessionStore: UserSessionStore, authRemoteAPI: AuthRemoteAPI) {
        self.userSessionStore = userSessionStore
        self.authRemoteAPI = authRemoteAPI
    }
    
    public func readUserSession() -> Promise<UserSession> {
        return userSessionStore.load()
    }
    
    public func signUp(newAccount: NewAccount) -> Promise<UserSession> {
        return authRemoteAPI.signUp(account: newAccount).then(userSessionStore.save(userSession:))
    }
    
    public func signIn(email: String, password: Secret) -> Promise<UserSession> {
        return authRemoteAPI.signIn(username: email, password: password).then(userSessionStore.save(userSession:))
    }
    
    public func signOut() -> Promise<Bool> {
        return userSessionStore.delete()
    }
    
    public func isSignedIn() -> Guarantee<Bool> {
        return firstly {
                readUserSession()
            }
            .then { _ in Guarantee.value(true)}
            .recover{ _ in Guarantee.value(false)}
    }
}
