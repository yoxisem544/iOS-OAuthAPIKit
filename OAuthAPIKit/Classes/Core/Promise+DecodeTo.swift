//
//  Promise+DecodeTo.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/23.
//

import PromiseKit
import Moya
import SwiftyJSON

extension Promise where T == Response {

    internal func decode<ResponseType: Decodable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then(on: decodingQueue, { response -> Promise<ResponseType> in
            return .value(try response.decode(to: type))
        })
    }

}

extension Promise where T == Response {

    internal func decodeToJSON() -> Promise<JSON> {
        return then(on: decodingQueue, { response -> Promise<JSON> in
            return .value(try response.decodeToJSON())
        })
    }

}

