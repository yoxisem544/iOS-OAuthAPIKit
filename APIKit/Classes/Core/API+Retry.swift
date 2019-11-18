//
//  API+Retry.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya
import PromiseKit
import SwiftyJSON

public protocol RetryableRquest {
    var retryInterval: DispatchTimeInterval { get }
    var retryCount: Int { get }
}

extension RetryableRquest {
    var retryInterval: DispatchTimeInterval { return .seconds(2) }
    var retryCount: Int { return 3 }
}

extension API.NetworkClient {

    public func request<Request: TargetType & RetryableRquest>(_ retryingRequest: Request) -> Promise<JSON> {
        return attempt(maximumRetryCount: retryingRequest.retryCount, delayBeforeRetry: retryingRequest.retryInterval, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attempt(maximumRetryCount: retryingRequest.retryCount, delayBeforeRetry: retryingRequest.retryInterval, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attempt(maximumRetryCount: retryingRequest.retryCount, delayBeforeRetry: retryingRequest.retryInterval, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

}

