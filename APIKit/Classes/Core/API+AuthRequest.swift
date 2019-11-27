//
//  API+AuthRequest.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import PromiseKit
import SwiftyJSON

/// AuthRequest is a flag for NetworkClient to notice that
/// requests conforms to this protocol won't be suspended by refresh request
public protocol AuthRequest {}

/// Thread to separate api call from which will be suspended.
fileprivate let authRequestQueue = DispatchQueue(label: "io.api.network_client.auth_request_queue")

extension API.NetworkClient {

    public func request<Request: TargetType & AuthRequest>(_ request: Request) -> Promise<JSON> {
        return perform(request, on: authRequestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decodeToJSON()
    }

    public func request<Request: TargetType & DecodableResponse & AuthRequest>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request, on: authRequestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

    public func request<Request: TargetType & MappableResponse & AuthRequest>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request, on: authRequestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

    public func request<Request: TargetType & ImmutableMappableResponse & AuthRequest>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request, on: authRequestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .decode(to: Request.ResponseType.self)
    }

}
