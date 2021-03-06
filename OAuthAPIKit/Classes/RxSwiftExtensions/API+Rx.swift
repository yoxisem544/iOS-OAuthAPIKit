//
//  API+Rx.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

// MARK: - Rx extension

extension API.NetworkClient: ReactiveCompatible {}

extension Reactive where Base == API.NetworkClient {

    internal func perform<Request: TargetType>(of request: Request) -> Single<Response> {
        if let retryBahavior = (request as? RetryableRquest)?.retryBehavior {
            return performRequest(of: request)
                .filterSuccessAndRedirectOrThrowNetworkClientError()
                .retry(retryBahavior)
        } else {
            return performRequest(of: request)
        }
    }

    internal func performRequest<Request: TargetType>(of request: Request) -> Single<Response> {
        let queue = { () -> DispatchQueue in
            return request is NonBlockableRequest ? nonBlockingRequestQueue : self.base.requestQueue
        }()
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: queue)
    }

}

// MARK: - SwiftyJSON + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType>(_ request: Request) -> Single<Response> {
        return performRequest(of: request).filterSuccessAndRedirectOrThrowNetworkClientError()
    }

    public func requestWithFilteringStatusCode<Request: TargetType>(_ request: Request) -> Single<Response> {
        return performRequest(of: request)
    }

}

// MARK: - DecodableResponse + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        return performRequest(of: request)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self, using: base.jsonDecoder)
    }

}

