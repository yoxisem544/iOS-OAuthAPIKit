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

    public func request<Request: TargetType & DecodableResponse>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request, on: requestQueue).map(Request.ResponseType.self)
    }

}

extension Promise where T == Response {

    internal func map<ResponseType: Decodable>(_ type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            do {
                return .value(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}
