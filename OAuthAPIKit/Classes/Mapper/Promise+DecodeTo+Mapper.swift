//
//  Promise+DecodeTo+Mapper.swift
//  OAuthAPIKit
//
//  Created by David on 2020/1/7.
//

import PromiseKit
import Moya
import Mapper

extension Promise where T == Response {

    internal func decode<ResponseType: Mappable>(to type: ResponseType.Type) -> Promise<ResponseType> {
        return then(on: decodingQueue, { response -> Promise<ResponseType> in
            return .value(try response.decode(to: type))
        })
    }

}
