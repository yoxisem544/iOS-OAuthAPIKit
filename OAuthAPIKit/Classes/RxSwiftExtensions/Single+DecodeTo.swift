//
//  Single+DecodeTo.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/22.
//

import Mapper
import Moya
import RxSwift
import SwiftyJSON

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    internal func decodeToJSON() -> Single<JSON> {
        return observeOn(decodingScheduler)
        .flatMap({ response -> Single<JSON> in
            return .just(try response.decodeToJSON())
        })
    }

    internal func decode<T: Mappable>(to type: T.Type) -> Single<T> {
        return observeOn(decodingScheduler)
        .flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }
    
    internal func decode<T: Decodable>(to type: T.Type) -> Single<T> {
        return observeOn(decodingScheduler)
        .flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }

}
