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

public protocol RetryableRquest {
    var retryBehavior: RepeatBehavior { get }
}

public extension RetryableRquest {
    /// Default to general delay with retry count 3 times, each retry with 2 seconds interval.
    var retryBehavior: RepeatBehavior { return .delayed(maxCount: 3, time: 2) }
}

extension API.NetworkClient {

    public func request<Request: TargetType & RetryableRquest>(_ retryingRequest: Request) -> Promise<JSON> {
        return attempt(retryingRequest.retryBehavior, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

    public func request<Request: TargetType & DecodableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attempt(retryingRequest.retryBehavior, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

    public func request<Request: TargetType & MappableResponse & RetryableRquest>(_ retryingRequest: Request) -> Promise<Request.ResponseType> {
        return attempt(retryingRequest.retryBehavior, {
            return self.perform(retryingRequest, on: self.requestQueue)
        })
    }

}
