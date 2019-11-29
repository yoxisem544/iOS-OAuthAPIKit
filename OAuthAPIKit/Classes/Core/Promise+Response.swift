//
//  Promise+Response.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/22.
//

import PromiseKit
import Moya

extension Promise where T == Response {

    internal func filteOrThrowNetworkClientErrorr<R: RangeExpression>(statusCodes: R) -> Promise<T> where R.Bound == Int {
        return compactMap({ try $0.filterOrThrowNetworkClientError(statusCodes: statusCodes) })
    }

    internal func filterSuccessAndRedirectOrThrowNetworkClientError() -> Promise<T> {
        return compactMap({ try $0.filterSuccessAndRedirectOrThrowNetworkClientError() })
    }

    internal func filterSuccessThrowNetworkClientError() -> Promise<T> {
        return compactMap({ try $0.filterSuccessOrThrowNetworkClientError() })
    }

}
