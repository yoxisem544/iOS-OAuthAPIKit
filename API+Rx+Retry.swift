//
//  API+Rx+Retry.swift
//  APIKit
//
//  Created by David on 2019/11/20.
//

import RxSwift
import ObjectMapper
import SwiftyJSON
import Moya

// MARK: - SwiftyJSON + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & RetryableRquest>(_ request: Request) -> Single<JSON> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map({ response in try JSON(data: response.data) })
    }

}

// MARK: - DecodableResponse + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self)
    }

}

// MARK: - MappableResponse + RxSwift + Retry
extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .retry(request.retryBehavior)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self)
    }

}
