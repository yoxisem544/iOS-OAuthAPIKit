//
//  API.swift
//  APIKit
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
        case otherError(error: MoyaError)
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

// MARK: - General Decoding with SwiftyJSON
extension API.NetworkClient {

    public func request<Request: TargetType>(_ request: Request) -> Promise<JSON> {
        return perform(request, on: requestQueue).mapJSON()
    }

}

extension API.NetworkClient {

    internal func perform<Request: TargetType>(_ request: Request, on callbackQueue: DispatchQueue) -> Promise<Response> {
        let target = MultiTarget(request)
        return Promise { seal in
            provider.request(target, callbackQueue: callbackQueue, completion: { response in
                switch response {
                case .success(let r):
                    do {
                        // filter code in range 200...399
                        try r.filterSuccessAndRedirectOrThrowNetworkClientError()
                        seal.fulfill(r)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let e):
                    seal.reject(API.NetworkClientError.otherError(error: e))
                }
            })
        }
    }

}

extension Promise where T == Response {

    func mapJSON() -> Promise<JSON> {
        return then({ response -> Promise<JSON> in
            do {
                return .value(try JSON(data: response.data))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

