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
            do {
                return .just(try JSON(data: response.data))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    internal func decode<T: Mappable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            do {
                return .just(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    internal func decode<T: ImmutableMappable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            do {
                return .just(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    internal func decode<T: Decodable>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            do {
                return .just(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}
