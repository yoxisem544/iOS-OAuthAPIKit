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
        return performRequest(of: request)
            .retry(request.retryBehavior)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decodeToJSON()
    }

}

// MARK: - DecodableResponse + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        return performRequest(of: request)
            .retry(request.retryBehavior)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}

// MARK: - MappableResponse + RxSwift + Retry
extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        return performRequest(of: request)
        .retry(request.retryBehavior)
        .filterSuccessAndRedirectOrThrowNetworkClientError()
        .decode(to: Request.ResponseType.self)
    }

}
