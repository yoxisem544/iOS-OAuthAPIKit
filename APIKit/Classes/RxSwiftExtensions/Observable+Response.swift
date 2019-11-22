//
//  Observable+Response.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import Moya
import RxSwift

extension ObservableType where E == Response {

    func filterSuccessAndRedirectOrThrowNetworkClientError() -> Observable<E> {
        return flatMap({ response -> Observable<E> in
            do {
                return .just(try response.filterSuccessAndRedirectOrThrowNetworkClientError())
            } catch {
                throw API.NetworkClientError.statucCodeError(error: error)
            }
        })
    }

    func filterSuccessOrThrowNetworkClientError() -> Observable<E> {
        return flatMap({ response -> Observable<E> in
            do {
                return .just(try response.filterSuccessOrThrowNetworkClientError())
            } catch {
                throw API.NetworkClientError.statucCodeError(error: error)
            }
        })
    }

}
