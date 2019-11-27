//
//  Response+DecodeTo.swift
//  APIKit
//
//  Created by David on 2019/11/25.
//

import PromiseKit
import Moya
import ObjectMapper
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

    internal func decode<ResponseType: Decodable>(to type: ResponseType.Type) throws -> ResponseType {
        do {
            return try self.map(type)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

}

extension Response {

    internal func decode<ResponseType: Mappable>(to type: ResponseType.Type) throws -> ResponseType {
        do {
            return try self.map(type)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

    internal func decode<ResponseType: ImmutableMappable>(to type: ResponseType.Type) throws -> ResponseType {
         do {
            return try self.map(type)
        } catch {
            throw API.NetworkClientError.decodingError(error: error)
        }
    }

}
