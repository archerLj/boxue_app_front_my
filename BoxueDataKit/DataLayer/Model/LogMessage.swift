//
//  LogMessage.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public struct LogMessage: Codable {
    
    public let id: UUID
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}

extension LogMessage: Equatable {
    public static func == (lhs: LogMessage, rhs: LogMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
