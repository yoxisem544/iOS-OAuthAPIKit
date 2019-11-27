//
//  Single+Response.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// Filters out responses that don't fall within the given closed range, generating errors when others are encountered.
    internal func filter<R: RangeExpression>(statusCodes: R) -> Single<ElementType> where R.Bound == Int {
        return flatMap { .just(try $0.filterOrThrowNetworkClientError(statusCodes: statusCodes)) }
    }

    internal func filterSuccessAndRedirectOrThrowNetworkClientError() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessAndRedirectOrThrowNetworkClientError()) }
    }

    internal func filterSuccessThrowNetworkClientError() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessOrThrowNetworkClientError()) }
    }

}
