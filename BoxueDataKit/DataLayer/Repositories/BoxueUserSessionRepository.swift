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
        
        // Promise中除了catch用来处理错误外，还有一个wrapper: recover也可以用来处理错误，
        // recover用来出了错误后，需要我们接管这个错误并把它恢复成某种正常状态的情况。他返回的是Promise<T>类型，显然catch是做不到的
        
        // 下面这里，如果读取用户session失败的话，我们就在recover里面把它恢复成false,表示
        // 未登陆就行了（这里，我们并不想把这个错误扩散出去。）。
        return firstly {
                readUserSession()
            }
            .then { _ in Guarantee.value(true)}
            .recover{ _ in Guarantee.value(false)}
        
        // 另外，Pormise给所有的wrapper提供了一个on参数，允许我们定义他们的closure执行的队列,因为所有的.then, .done都是执行在
        // 主线程的，有时候我们需要执行在其他的线程来处理一些耗时操作
    }
}
