//
//  Single+DecodeTo+Mapper.swift
//  OAuthAPIKit
//
//  Created by David on 2020/1/7.
//

import Mapper
import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    internal func decode<T: Mappable>(to type: T.Type) -> Single<T> {
        return observeOn(decodingScheduler)
        .flatMap({ response -> Single<T> in
            return .just(try response.decode(to: type))
        })
    }

}
