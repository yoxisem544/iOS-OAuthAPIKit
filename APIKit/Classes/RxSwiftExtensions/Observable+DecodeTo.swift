//
//  Observable+DecodeTo.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import ObjectMapper
import Moya
import RxSwift
import SwiftyJSON

extension ObservableType where E == Response {

    internal func decodeToJSON() -> Observable<JSON> {
        return flatMap({ response -> Observable<JSON> in
            return .just(try response.decodeToJSON())
        })
    }

    internal func decode<T: Mappable>(to type: T.Type) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            return .just(try response.decode(to: type))
        })
    }

    internal func decode<T: ImmutableMappable>(to type: T.Type) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            return .just(try response.decode(to: type))
        })
    }

    internal func decode<T: Decodable>(to type: T.Type) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            return .just(try response.decode(to: type))
        })
    }

}
