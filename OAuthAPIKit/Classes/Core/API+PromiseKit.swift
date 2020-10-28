//
//  API+PromiseKit.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/20.
//

import Moya
import PromiseKit
import SwiftyJSON

// MARK: - General Decoding with SwiftyJSON

extension API.NetworkClient {

    public func request<Request: TargetType>(_ request: Request) -> Promise<Response> {
        return perform(request).filterSuccessAndRedirectOrThrowNetworkClientError()
    }

    public func requestWithFilteringStatusCode<Request: TargetType>(_ request: Request) -> Promise<Response> {
        return perform(request)
    }

}

// MARK: - For Decodable protocol

extension API.NetworkClient {

    public func request<Request: TargetType & DecodableResponse>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self, using: jsonDecoder)
    }

}
