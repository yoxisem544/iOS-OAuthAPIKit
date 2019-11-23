//
//  Promise+DecodeTo.swift
//  APIKit
//
//  Created by David on 2019/11/23.
//

import PromiseKit
import Moya
import ObjectMapper
import SwiftyJSON

extension Promise where T == Response {

    internal func decode<ResponseType: Mappable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            do {
                return .value(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    internal func decode<ResponseType: ImmutableMappable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            do {
                return .value(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

extension Promise where T == Response {

    internal func decode<ResponseType: Decodable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            do {
                return .value(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

extension Promise where T == Response {

    internal func decodeToJSON() -> Promise<JSON> {
        return then({ response -> Promise<JSON> in
            do {
                return .value(try JSON(data: response.data))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

