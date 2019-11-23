//
//  Observable+ObjectMapper.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import RxSwift
import ObjectMapper
import Moya

extension ObservableType where E == Response {

    public func map<T: Mappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Observable<[S.Element]> where S.Element: Mappable {
        return flatMap({ response -> Observable<[S.Element]> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Observable<[S.Element]> where S.Element: ImmutableMappable {
        return flatMap({ response -> Observable<[S.Element]> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

