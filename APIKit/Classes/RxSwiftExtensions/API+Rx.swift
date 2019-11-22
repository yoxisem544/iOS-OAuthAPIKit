//
//  API+Rx.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

// MARK: - Rx extension

extension API.NetworkClient: ReactiveCompatible {}

// MARK: - SwiftyJSON + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType>(_ request: Request) -> Single<JSON> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decodeToJSON()
    }

}

// MARK: - DecodableResponse + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}

// MARK: - MappableResponse + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}
