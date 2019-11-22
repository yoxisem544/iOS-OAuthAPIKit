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
            .retry(request.retryBehavior)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .flatMap({
                do {
                    return .just(try JSON(data: $0.data))
                } catch {
                    throw API.NetworkClientError.decodingError(error: error)
                }
            })
    }

}

// MARK: - DecodableResponse + RxSwift + Retry

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .retry(request.retryBehavior)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .flatMap({
                do {
                    return .just(try $0.map(Request.ResponseType.self))
                } catch {
                    throw API.NetworkClientError.decodingError(error: error)
                }
            })
    }

}

// MARK: - MappableResponse + RxSwift + Retry
extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .retry(request.retryBehavior)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .flatMap({
                do {
                    return .just(try $0.map(Request.ResponseType.self))
                } catch {
                    throw API.NetworkClientError.decodingError(error: error)
                }
            })
    }

}
