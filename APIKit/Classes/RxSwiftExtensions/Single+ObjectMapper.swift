//
//  Single+ObjectMapper.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import RxSwift
import ObjectMapper
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    public func map<T: Mappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap({ response -> Single<T> in
            do {
                return Single.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Single<[S.Element]> where S.Element: Mappable {
        return flatMap({ response -> Single<[S.Element]> in
            do {
                return Single.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap({ response -> Single<T> in
            do {
                return Single.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Single<[S.Element]> where S.Element: ImmutableMappable {
        return flatMap({ response -> Single<[S.Element]> in
            do {
                return Single.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}
