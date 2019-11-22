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

    public func map<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Observable<[S.Element]> where S.Element: BaseMappable {
        return flatMap({ response -> Observable<[S.Element]> in
            do {
                return Observable.just(try response.map(type, context: context))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

