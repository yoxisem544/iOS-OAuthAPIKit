//
//  User.swift
//  APIKit_Example
//
//  Created by David on 2019/11/20.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import ObjectMapper

struct User {
    var name: String?
    var id: String?

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

//extension User: Mappable {
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        name <- map["name"]
//        id <- map["id"]
//    }
//}

extension User: ImmutableMappable {
    init(map: Map) throws {
        name = try map.value("name")
        id = try map.value("id")
    }
}
