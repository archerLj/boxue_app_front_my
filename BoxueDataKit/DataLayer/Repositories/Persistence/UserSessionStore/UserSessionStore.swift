//
//  UserSessionStore.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserSessionStore {
    func save(userSession: UserSession) -> Promise<UserSession>
    func load() -> Promise<UserSession>
    func delete() -> Promise<Bool>
}
