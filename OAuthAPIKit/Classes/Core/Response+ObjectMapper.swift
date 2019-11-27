//
//  Response+ObjectMapper.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import ObjectMapper

extension Response {

    /// Transform a Mappable to instance from a Moya Response.
    ///
    /// - Parameters:
    ///   - type: Type to be tranformed that conforms to Mappable.
    ///   - context: a MapContext
    public func map<T: Mappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        let mapper = Mapper<T>(context: context)
        guard let result = mapper.map(JSONObject: try mapJSON()) else { throw MoyaError.jsonMapping(self) }
        return result
    }

    /// Transform a Mappable sequence to instance from a Moya Response.
    /// 
    /// You don't need to call mapArray to from ObjectMapper.
    /// Simply call:
    /// ```
    /// try response.map([SomeType].self)
    /// ```
    ///
    /// - Parameters:
    ///   - type: Type to be tranformed that conforms to Mappable.
    ///   - context: a MapContext
    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) throws -> [S.Element] where S.Element: Mappable {
        let mapper = Mapper<S.Element>(context: context)
        guard let result = mapper.mapArray(JSONObject: try mapJSON()) else { throw MoyaError.jsonMapping(self) }
        return result
    }

}

extension Response {

    /// Maps data received from the signal into an object which implements the ImmutableMappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        return try Mapper<T>(context: context).map(JSONObject: try mapJSON())
    }

    /// Transform a ImmutableMappable sequence to instance from a Moya Response.
    ///
    /// You don't need to call mapArray to from ObjectMapper.
    /// Simply call:
    /// ```
    /// try response.map([SomeType].self)
    /// ```
    ///
    /// - Parameters:
    ///   - type: Type to be tranformed that conforms to ImmutableMappable.
    ///   - context: a MapContext
    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) throws -> [S.Element] where S.Element: ImmutableMappable {
        let mapper = Mapper<S.Element>(context: context)
        do {
            return try mapper.mapArray(JSONObject: try mapJSON())
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

}
