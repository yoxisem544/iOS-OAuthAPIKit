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

    public func request<Reqeust: TargetType & AuthRequest>(_ request: Reqeust) -> Promise<JSON> {
        return perform(request, on: authRequestQueue)
    }

    public func request<Reqeust: TargetType & MappableResponse & AuthRequest>(_ request: Reqeust) -> Promise<Reqeust.ResponseType> {
        return perform(request, on: authRequestQueue)
    }

}
