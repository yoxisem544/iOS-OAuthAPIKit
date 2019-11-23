//
//  RetryProfile.swift
//  APIKit_Example
//
//  Created by David on 2019/11/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import ObjectMapper

public struct RetryProfile {
    let info: String
    let username: String
}

extension RetryProfile: ImmutableMappable {
    public init(map: Map) throws {
        self.info = try map.value("data~>info", delimiter: "~>")
        self.username = try map.value("data~>username", delimiter: "~>")
    }
}
