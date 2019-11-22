//
//  Single+Response.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func filterSuccessAndRedirectOrThrowNetworkClientError() -> Single<Element> {
        return flatMap({ response -> Single<Element> in
            do {
                return .just(try response.filterSuccessAndRedirectOrThrowNetworkClientError())
            } catch {
                throw API.NetworkClientError.statucCodeError(error: error)
            }
        })
    }

    func filterSuccessThrowNetworkClientError() -> Single<Element> {
        return flatMap({ response -> Single<Element> in
            do {
                return .just(try response.filterSuccessOrThrowNetworkClientError())
            } catch {
                throw API.NetworkClientError.statucCodeError(error: error)
            }
        })
    }

}
