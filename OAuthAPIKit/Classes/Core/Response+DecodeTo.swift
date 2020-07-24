//
//  Response+DecodeTo.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/25.
//

import Moya
import SwiftyJSON

extension Response {

    internal func decodeToJSON() throws -> JSON {
        do {
            return try JSON(data: self.data)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

}

extension Response {

    internal func decode<ResponseType: Decodable>(to type: ResponseType.Type, using decoder: JSONDecoder = .init()) throws -> ResponseType {
        do {
            return try self.map(type, using: decoder)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

}
