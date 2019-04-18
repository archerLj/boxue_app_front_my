//
//  FakeUserSessionStore.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public class FakeUserSessionStore: UserSessionStore {
    
    /// - Properties
    let hasToken: Bool
    
    /// - Methods
    public init(hasToken: Bool) {
        self.hasToken = hasToken
    }
    
    public func save(userSession: UserSession) -> Promise<UserSession> {
        return Promise.value(userSession)
    }
    
    public func load() -> Promise<UserSession> {
        return hasToken ? withToken() : withoutToken()
    }
    
    public func delete() -> Promise<Bool> {
        return Promise.value(true)
    }
    
    public func withToken() -> Promise<UserSession> {
        let profile = UserProfile(name:Fake.name, email: Fake.email, mobile: Fake.mobile, avatar: Fake.avatar)
        let remoteSession = RemoteUserSession(token: Fake.token)
        
        return Promise.value(UserSession(profile: profile, remoteUserSession: remoteSession))
    }
    
    public func withoutToken() -> Promise<UserSession> {
        return Promise.init(error: DataKitError.any)
    }
}
