//
//  API+PromiseKit+ObjectMapper.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import PromiseKit
import ObjectMapper

// MARK: - For ObjectMapper
extension API.NetworkClient {

    internal func perform<Request: TargetType & MappableResponse>(_ request: Request, on callbackQueue: DispatchQueue) -> Promise<Request.ResponseType> {
        let target = MultiTarget(request)
        return Promise { seal in
            provider.request(target, callbackQueue: callbackQueue, completion: { response in
                switch response {
                case .success(let r):
                    // check status code if 200~399, 200~299 is success status, 300~399 is for redirect
                    do {
                        try r.filterSuccessAndRedirectOrThrowNetworkClientError()
                        do {
                            seal.fulfill(try r.map(Request.ResponseType.self))
                        } catch {
                            seal.reject(API.NetworkClientError.decodingError(error: error))
                        }
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let e):
                    seal.reject(API.NetworkClientError.otherError(error: e))
                }
            })
        }
    }

    public func request<R: TargetType & MappableResponse>(_ request: R) -> Promise<R.ResponseType> {
        return perform(request, on: requestQueue)
    }

}

