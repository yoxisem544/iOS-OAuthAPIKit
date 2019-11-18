//
//  API+RefreshToken.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya
import PromiseKit
import SwiftyJSON

protocol TokenRefreshingRequest {}

fileprivate let tokenRefreshQueue = DispatchQueue(label: "io.api.network_client.token_refresh_queue")

extension API.NetworkClient {

    func request<Reqeust: TargetType & TokenRefreshingRequest>(_ request: Reqeust) -> Promise<JSON> {
        return perform(request, on: tokenRefreshQueue)
    }

    func request<Reqeust: TargetType & MappableResponse & TokenRefreshingRequest>(_ request: Reqeust) -> Promise<Reqeust.ResponseType> {
        return perform(request, on: tokenRefreshQueue)
    }

}

