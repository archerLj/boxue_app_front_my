//
//  FakeAuthRemoteAPI.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

struct Fake {
    static let email = "lj0011977@163.com"
    static let password = "123456"
    static let name = "archer"
    static let mobile = "18012690219"
    static let avatar = makeURL()
    static let token = "testToken"
}

public struct FakeAuthRemoteAPI: AuthRemoteAPI {
    
    
    public func signIn(username: String, password: Secret) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            guard username == Fake.email && password == Fake.password else {
                return seal.reject(DataKitError.any)
            }
            
            let profile = UserProfile(name: Fake.name, email: Fake.email, mobile: Fake.mobile, avatar: Fake.avatar)
            let remoteSession = RemoteUserSession(token: Fake.token)
            let userSession = UserSession(profile: profile, remoteUserSession: remoteSession)
            
            seal.fulfill(userSession)
        }
    }
    
    public func signUp(account: NewAccount) -> Promise<UserSession> {
        let profile = UserProfile(name: account.name, email: account.email, mobile: account.mobile, avatar: makeURL())
        
        let remoteSession = RemoteUserSession(token: Fake.token)
        let userSession = UserSession(profile: profile, remoteUserSession: remoteSession)
        
        return Promise.value(userSession)
    }
    
    public init() {}
    
    
}
