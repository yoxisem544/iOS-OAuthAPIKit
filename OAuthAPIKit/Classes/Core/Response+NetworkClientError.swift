//
//  Response+NetworkClientError.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/22.
//

import Moya

extension Response {

    /**
     Returns the `Response` if the `statusCode` falls within the specified range.

     - parameters:
        - statusCodes: The range of acceptable status codes.
     - throws: `MoyaError.statusCode` when others are encountered.
    */
    func filterOrThrowNetworkClientError<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        do {
            return try filter(statusCodes: 200...399)
        } catch {
            throw API.NetworkClientError.statucCodeError(error: error)
        }
    }

    @discardableResult
    func filterSuccessAndRedirectOrThrowNetworkClientError() throws -> Response {
        return try filterOrThrowNetworkClientError(statusCodes: 200...399)
    }

    @discardableResult
    func filterSuccessOrThrowNetworkClientError() throws -> Response {
        return try filterOrThrowNetworkClientError(statusCodes: 200...299)
    }

}
