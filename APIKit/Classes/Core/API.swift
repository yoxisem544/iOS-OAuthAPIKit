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
        return perform(request, on: requestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .mapJSON()
    }

}

extension API.NetworkClient {

    internal func perform<Request: TargetType>(_ request: Request, on callbackQueue: DispatchQueue) -> Promise<Response> {
        let target = MultiTarget(request)
        return Promise { seal in
            provider.request(target, callbackQueue: callbackQueue, completion: { response in
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

extension Promise where T == Response {

    internal func filter<R: RangeExpression>(statusCodes: R) -> Promise<T> where R.Bound == Int {
        return compactMap({ try $0.filterOrThrowNetworkClientError(statusCodes: statusCodes) })
    }

    internal func filterSuccessAndRedirectOrThrowNetworkClientError() -> Promise<T> {
        return compactMap({ try $0.filterSuccessAndRedirectOrThrowNetworkClientError() })
    }

    internal func filterSuccessThrowNetworkClientError() -> Promise<T> {
        return compactMap({ try $0.filterSuccessOrThrowNetworkClientError() })
    }

}

extension Promise where T == Response {

    internal func mapJSON() -> Promise<JSON> {
        return then({ response -> Promise<JSON> in
            do {
                return .value(try JSON(data: response.data))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}

