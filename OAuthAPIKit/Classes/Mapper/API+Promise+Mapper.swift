//
//  API+Promise+Mapper.swift
//  OAuthAPIKit
//
//  Created by David on 2020/1/7.
//

import Moya
import Mapper
import PromiseKit

// MARK: - For Mapper

extension API.NetworkClient {

    public func request<Request: TargetType & MappableResponse>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}
