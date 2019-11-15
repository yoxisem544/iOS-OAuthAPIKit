//
//  Single+ObjectMapper.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import RxSwift
import ObjectMapper
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    public func map<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap({ response -> Single<T> in
            return Single.just(try response.map(type, context: context))
        })
    }

    public func map<S: Sequence>(_ type: S.Type, context: MapContext? = nil) -> Single<[S.Element]> where S.Element: BaseMappable {
        return flatMap({ response -> Single<[S.Element]> in
            return Single.just(try response.map(type, context: context))
        })
    }

}
