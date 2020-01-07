//
//  Response+DecodeTo+Mapper.swift
//  OAuthAPIKit
//
//  Created by David on 2020/1/7.
//

import Moya
import Mapper

extension Response {

    internal func decode<ResponseType: Mappable>(to type: ResponseType.Type) throws -> ResponseType {
        do {
            return try self.map(type)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

}

