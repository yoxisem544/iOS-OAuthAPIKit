//
//  API+Rx.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya
import RxSwift

// MARK: - Rx extension
extension API.NetworkClient: ReactiveCompatible {}

extension Reactive where Base == API.NetworkClient {

    // 每當我傳入一個 request 時，我都會檢查他的 response 可不可以被 decode，
    // conform DecodableResponseTargetType 的意義在此，
    // 因為我們已經先定好 ResponseType 是什麼了，
    // 儘管 request 不知道確定是什麼型態，但一定可以被 JSONDecoder 解析。
    func request<Request: TargetType & DecodableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self) // 在此會解析 Response，具體怎麼解析，交由 data model 的 decodable 去處理。
    }


    func request<Request: TargetType>(_ request: Request, failsOnEmptyData: Bool = false) -> Single<Any> {
        let target = MultiTarget.init(request)
        return base.provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .mapJSON(failsOnEmptyData: failsOnEmptyData)
    }

}

extension Reactive where Base == API.NetworkClient {

    func request<Request: TargetType & MappableResponse>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self)
    }

}

extension Reactive where Base == API.NetworkClient {

    func request<Request: TargetType & MappableResponse & RetryableRquest>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return base.provider.rx.request(target, callbackQueue: base.requestQueue)
            .retry(RepeatBehavior.delayed(maxCount: UInt(request.retryCount), time: request.retryInterval.toDoubleValue()))
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self)
    }

}
