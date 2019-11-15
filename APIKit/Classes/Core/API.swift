//
//  API.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Result
import Moya
import PromiseKit
import Alamofire
import SwiftyJSON
import ObjectMapper

public typealias Method = HTTPMethod

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

// 定義一個 protocol 需要預先指定 response 的 type
protocol DecodableResponse {
    associatedtype ResponseType: Decodable
    var jsonDecodingEntryPath: String? { get }
}

extension DecodableResponse {
    // default to no json entry point
    var jsonDecodingEntryPath: String? { return nil }
}

protocol MappableResponse {
    associatedtype ResponseType: BaseMappable
}

final public class API {

    public enum NetworkClientError: Error {
        case clientSideError(statusCode: Int, errorMessage: ServerErrorMessage?)
        case serverSideError(statusCode: Int, errorMessage: ServerErrorMessage?)
        case undefinedError
    }

    public struct NetworkClient {

        // MARK: - Property
        internal let requestQueue = DispatchQueue(label: "io.api.network_client.request_queue")

        // MARK: Initialization
        init(provider: MoyaProvider<MultiTarget>) {
            self.provider = provider
        }
        let provider: MoyaProvider<MultiTarget>

        func handleErrorResponse(_ r: Response) -> API.NetworkClientError {
            let message = try? r.map(ServerErrorMessage.self)
            switch r.statusCode {
            case 400...499:
                return API.NetworkClientError.clientSideError(statusCode: r.statusCode, errorMessage: message)
            case 500...599:
                return API.NetworkClientError.serverSideError(statusCode: r.statusCode, errorMessage: message)
            default:
                return API.NetworkClientError.undefinedError
            }
        }

        public func blockRequestQueue() {
            requestQueue.suspend()
        }

        public func releaseRequestQueue() {
            requestQueue.resume()
        }
    }

    /// Default api client
    public static let shared: NetworkClient = {
        let tokenRefreshPlugin = TokenRefreshingPlugin()
        let plugins: [PluginType] = [
            NetworkTrafficPlugin.init(indicatorType: .start, .done),
            XAuthHeaderInjectingPlugin(),
            tokenRefreshPlugin
        ]
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        let client = NetworkClient(provider: provider)
        tokenRefreshPlugin.networkClientRef = client
        return client
    }()

    // API singleton
    private init() {}

}

// MARK: - General Decoding with SwiftyJSON
extension API.NetworkClient {

    func request<Request: TargetType>(_ request: Request) -> Promise<JSON> {
        return perform(request, on: requestQueue)
    }

}

extension API.NetworkClient {

    internal func perform<Request: TargetType>(_ request: Request, on callbackQueue: DispatchQueue) -> Promise<JSON> {
        let target = MultiTarget(request)
        return Promise { seal in
            provider.request(target, callbackQueue: callbackQueue, completion: { response in
                switch response {
                case .success(let r):
                    do {
                        switch r.statusCode {
                        case 200...399:
                            seal.fulfill(try JSON(data: r.data))
                        default:
                            seal.reject(self.handleErrorResponse(r))
                        }
                    } catch let e {
                        seal.reject(e)
                    }
                case .failure(let e):
                    seal.reject(e)
                }
            })
        }
    }

}
