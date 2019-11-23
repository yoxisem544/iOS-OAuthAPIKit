//
//  API+Retry.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import SwiftyJSON

/// For requests that needs retry behavior
public protocol RetryableRquest {
    var retryBehavior: RepeatBehavior { get }
}

public extension RetryableRquest {
    /// Default to general delay with retry count 3 times, each retry with 2 seconds interval.
    var retryBehavior: RepeatBehavior { return .delayed(maxCount: 3, time: 2) }
}

extension API.NetworkClient {

    internal func attemptRequest<Request: TargetType & RetryableRquest>(_ retryingRequest: Request) -> Promise<Response> {
        return attempt(retryingRequest.retryBehavior, {
            self.perform(retryingRequest, on: self.requestQueue).filterSuccessAndRedirectOrThrowNetworkClientError()
        })
    }

    public func request<Request: TargetType & RetryableRquest>(_ retryingRequest: Request) -> Promise<JSON> {
        return attemptRequest(retryingRequest).mapJSON()
    }

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attemptRequest(retryingRequest).map(Request.ResponseType.self)
    }

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attemptRequest(retryingRequest).map(Request.ResponseType.self)
    }

}
