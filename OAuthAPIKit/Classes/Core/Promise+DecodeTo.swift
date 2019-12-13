//
//  Promise+DecodeTo.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/23.
//

import PromiseKit
import Moya
import Mapper
import SwiftyJSON

extension Promise where T == Response {

    internal func decode<R: Mappable>(to type: R.Type) -> Promise<R> {
        return then(on: decodingQueue, { response -> Promise<R> in
            return .value(try response.decode(to: type))
        })
    }

}

extension Promise where T == Response {

    internal func decode<R: Decodable>(to type: R.Type) -> Promise<R> {
        return then(on: decodingQueue, { response -> Promise<R> in
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

