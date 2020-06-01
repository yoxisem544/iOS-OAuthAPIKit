//
//  API.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import PromiseKit
import SwiftyJSON

public typealias Method = Moya.Method
public typealias Task = Moya.Task
public typealias URLEncoding = Moya.URLEncoding
public typealias JSONEncoding = Moya.JSONEncoding

final public class API {

    public enum NetworkClientError: Error {
        case statucCodeError(error: Error)
        case decodingError(error: Error)
    }

    public struct NetworkClient {

        // MARK: - Property
        internal let requestQueue = DispatchQueue(label: "io.api.network_client.request_queue")

        // MARK: Initialization
        public init(provider: MoyaProvider<MultiTarget>) {
            self.provider = provider
        }
        let provider: MoyaProvider<MultiTarget>

        public func blockRequestQueue() {
            requestQueue.suspend()
        }

        public func releaseRequestQueue() {
            requestQueue.resume()
        }
    }

    /// Default api client
    public static let shared: NetworkClient = {
        let plugins: [PluginType] = [
            NetworkTrafficPlugin(indicators: .start, .done),
        ]
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        let client = NetworkClient(provider: provider)
        return client
    }()

    // API singleton
    private init() {}

}

extension API.NetworkClient {

    internal func perform<Request: TargetType>(_ request: Request) -> Promise<Response> {
        if let retryBahavior = (request as? RetryableRquest)?.retryBehavior {
            return attempt(retryBahavior, {
                self.performRequest(request).filterSuccessAndRedirectOrThrowNetworkClientError()
            })
        } else {
            return performRequest(request)
        }
    }

    fileprivate func performRequest<Request: TargetType>(_ request: Request) -> Promise<Response> {
        let target = MultiTarget(request)
        let queue = { () -> DispatchQueue in
            return request is NonBlockableRequest ? nonBlockingRequestQueue : self.requestQueue
        }()
        return Promise { seal in
            provider.request(target, callbackQueue: queue, completion: { response in
                switch response {
                case .success(let r):
                    seal.fulfill(r)
                case .failure(let e):
                    seal.reject(e)
                }
            })
        }
    }

}
