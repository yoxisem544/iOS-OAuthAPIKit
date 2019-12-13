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

extension Userr: Mappable {
    public init(map: Mapper) throws {
        username = try map.from("username")
        userID = try map.from("user_id")
    }
}
