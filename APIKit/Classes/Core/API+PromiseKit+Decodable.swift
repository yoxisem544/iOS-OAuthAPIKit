//
//  API+PromiseKit+Decodable.swift
//  APIKit
//
//  Created by David on 2019/11/20.
//

import Moya
import PromiseKit

// MARK: - For Decodable protocol
extension API.NetworkClient {

    internal func perform<Request: TargetType & DecodableResponse>(_ request: Request, on callbackQueue: DispatchQueue, atKeyPath path: String? = nil, failsOnEmptyData: Bool = true) -> Promise<Request.ResponseType> {
        let target = MultiTarget(request)
        return Promise { seal in
            provider.request(target, callbackQueue: callbackQueue, completion: { response in
                switch response {
                case .success(let r):
                    do {
                        // check status code if 200~399, 200~299 is success status, 300~399 is for redirect
                        switch r.statusCode {
                        case 200...399:
                            let result = try { () -> Request.ResponseType in
                                if let path = path {
                                    return try r.map(Request.ResponseType.self, atKeyPath: path, using: JSONDecoder(), failsOnEmptyData: failsOnEmptyData)
                                } else {
                                    return try r.map(Request.ResponseType.self)
                                }
                                }()
                            seal.fulfill(result)
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

    public func request<Request: TargetType & DecodableResponse>(_ request: Request, atKeyPath path: String? = nil, failsOnEmptyData: Bool = true) -> Promise<Request.ResponseType> {
        return perform(request, on: requestQueue, atKeyPath: path, failsOnEmptyData: failsOnEmptyData)
    }

    public func request<Request: TargetType & DecodableResponse>(_ r: Request) -> Promise<Request.ResponseType> {
        return request(r, atKeyPath: r.jsonDecodingEntryPath, failsOnEmptyData: true)
    }

}
