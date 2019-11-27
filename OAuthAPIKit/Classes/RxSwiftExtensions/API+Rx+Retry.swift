//
//  API+Rx+Retry.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/20.
//

import RxSwift
import ObjectMapper
import SwiftyJSON
import Moya

extension Reactive where Base == API.NetworkClient {

    public func attemptRequest<Request: TargetType & RetryableRquest>(of request: Request) -> Single<Response> {
        return performRequest(of: request)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .retry(request.retryBehavior)
    }

}

// MARK: - SwiftyJSON + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & RetryableRquest>(_ request: Request) -> Single<JSON> {
        return attemptRequest(of: request).decodeToJSON()
    }

}

// MARK: - DecodableResponse + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        return attemptRequest(of: request).decode(to: Request.ResponseType.self)
    }

}

// MARK: - MappableResponse + RxSwift + Retry
extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        return attemptRequest(of: request).decode(to: Request.ResponseType.self)
    }

    public func request<Request: TargetType & ImmutableMappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        return attemptRequest(of: request).decode(to: Request.ResponseType.self)
    }

}
