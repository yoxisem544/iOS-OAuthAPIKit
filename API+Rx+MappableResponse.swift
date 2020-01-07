//
//  API+Rx+MappableResponse.swift
//  OAuthAPIKit
//
//  Created by David on 2020/1/7.
//

import Moya
import RxSwift

// MARK: - MappableResponse + RxSwift

extension Reactive where Base == API.NetworkClient {

    public func request<Request: TargetType & MappableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        return performRequest(of: request)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}
