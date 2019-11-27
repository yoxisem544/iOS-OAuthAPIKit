//
//  Single+DecodeTo.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import ObjectMapper
import Moya
import RxSwift
import SwiftyJSON

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    internal func decodeToJSON() -> Single<JSON> {
        return flatMap({ response -> Single<JSON> in
            return .just(try response.decodeToJSON())
        })
    }

    internal func decode<T: Mappable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }

    internal func decode<T: ImmutableMappable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }

    internal func decode<T: Decodable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }

}
