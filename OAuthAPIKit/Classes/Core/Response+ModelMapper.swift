//
//  Response+ModelMapper.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import Mapper

extension Response {

    public func map<T: Mappable>(_ type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }

        do {
            return try T(map: Mapper(JSON: jsonDictionary))
        } catch {
            throw MoyaError.underlying(error, self)
        }
    }

    public func map<T: Mappable>(_ type: [T].Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [NSDictionary] else {
            throw MoyaError.jsonMapping(self)
        }

        do {
            return try jsonArray.map({ try T(map: Mapper(JSON: $0)) })
        } catch {
            throw MoyaError.underlying(error, self)
        }
    }

    public func compactMap<T: Mappable>(_ type: [T].Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [NSDictionary] else {
            throw MoyaError.jsonMapping(self)
        }

        return jsonArray.compactMap({ try? T(map: Mapper(JSON: $0)) })
    }

}
