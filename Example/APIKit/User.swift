//
//  User.swift
//  APIKit_Example
//
//  Created by David on 2019/11/20.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import ObjectMapper

struct User {
    let name: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, id
    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
    }
}

extension User: ImmutableMappable {
    init(map: Map) throws {
        name = try map.value("name")
        id = try map.value("id")
    }
}

