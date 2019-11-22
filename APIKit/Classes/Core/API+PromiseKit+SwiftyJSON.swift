//
//  API+PromiseKit+SwiftyJSON.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import PromiseKit
import SwiftyJSON
import Moya

// MARK: - General Decoding with SwiftyJSON
extension API.NetworkClient {

    public func request<Request: TargetType>(_ request: Request) -> Promise<JSON> {
        return perform(request, on: requestQueue)
            .filterSuccessAndRedirectOrThrowNetworkClientError()
            .mapJSON()
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

