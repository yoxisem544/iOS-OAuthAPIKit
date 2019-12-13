//
//  User.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Mapper

public struct Userr {
    let username: String
    let userID: String
}

extension Userr: ImmutableMappable {
    public init(map: Map) throws {
        username = try map.value("username")
        userID = try map.value("user_id")
    }
}
