//
//  Response+NetworkClientError.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import Moya

extension Response {

    @discardableResult
    func filterSuccessAndRedirectOrThrowNetworkClientError() throws -> Response {
        do {
            return try filter(statusCodes: 200...399)
        } catch {
            throw API.NetworkClientError.statucCodeError(error: error)
        }
    }

    @discardableResult
    func filterSuccessOrThrowNetworkClientError() throws -> Response {
        do {
            return try filter(statusCodes: 200...299)
        } catch {
            throw API.NetworkClientError.statucCodeError(error: error)
        }
    }

}
