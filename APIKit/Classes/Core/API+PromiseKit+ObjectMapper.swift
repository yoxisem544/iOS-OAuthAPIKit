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

    public func request<Request: TargetType & MappableResponse>(_ request: Request) -> Promise<Request.ResponseType> {
        return perform(request, on: requestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .map(Request.ResponseType.self)
    }

}

extension Promise where T == Response {

    internal func map<ResponseType: BaseMappable>(_ type: ResponseType.Type) -> Promise<ResponseType> {
        return then({ response -> Promise<ResponseType> in
            do {
                return .value(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}
