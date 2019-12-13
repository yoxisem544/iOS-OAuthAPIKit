//
//  RetryProfile.swift
//  APIKit_Example
//
//  Created by David on 2019/11/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Mapper

public struct RetryProfile {
    let info: String
    let username: String
}

extension RetryProfile: Mappable {
    public init(map: Mapper) throws {
        self.info = try map.from("data.info")
        self.username = try map.from("data.username")
    }
}
