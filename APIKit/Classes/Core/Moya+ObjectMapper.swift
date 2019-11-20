//
//  Moya+ObjectMapper.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import ObjectMapper

extension Response {

    public func map<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        let mapper = Mapper<T>(context: context)
        guard let result = mapper.map(JSONObject: try mapJSON()) else { throw MoyaError.jsonMapping(self) }
        return result
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) throws -> [S.Element] where S.Element: BaseMappable {
        let mapper = Mapper<S.Element>(context: context)
        guard let result = mapper.mapArray(JSONObject: try mapJSON()) else { throw MoyaError.jsonMapping(self) }
        return result
    }

}
