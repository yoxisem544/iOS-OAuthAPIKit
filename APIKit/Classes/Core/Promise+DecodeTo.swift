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
            return .value(try response.decode(to: type))
        })
    }

    internal func decode<ResponseType: ImmutableMappable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            return .value(try response.decode(to: type))
        })
    }

}

extension Promise where T == Response {

    internal func decode<ResponseType: Decodable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            return .value(try response.decode(to: type))
        })
    }

}

extension Promise where T == Response {

    internal func decodeToJSON() -> Promise<JSON> {
        return then({ response -> Promise<JSON> in
            return .value(try response.decodeToJSON())
        })
    }

}

