//
//  Observable+Response.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/22.
//

import Moya
import RxSwift

extension ObservableType where E == Response {

    /// Filters out responses that don't fall within the given closed range, generating errors when others are encountered.
    internal func filter<R: RangeExpression>(statusCodes: R) -> Observable<E> where R.Bound == Int {
        return flatMap { Observable.just(try $0.filterOrThrowNetworkClientError(statusCodes: statusCodes)) }
    }

    internal func filterSuccessAndRedirectOrThrowNetworkClientError() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessAndRedirectOrThrowNetworkClientError()) }
    }

    internal func filterSuccessThrowNetworkClientError() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessOrThrowNetworkClientError()) }
    }

}
