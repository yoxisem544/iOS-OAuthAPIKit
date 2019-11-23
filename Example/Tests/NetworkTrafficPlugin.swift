//
//  NetworkTrafficPlugin.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Moya

final public class NetworkTraffic2Plugin: PluginType {

    private let prepareClosure: ((_ request: URLRequest, _ target: TargetType) -> Void)?
    private let willSendClosure: ((_ request: RequestType, _ target: TargetType) -> Void)?
    private let didReceiveClosure: ((_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void)?
    private let processClosure: ((_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void)?

    public init(
        prepareClosure: ((_ request: URLRequest, _ target: TargetType) -> Void)?,
        willSendClosure: ((_ request: RequestType, _ target: TargetType) -> Void)?,
        didReceiveClosure: ((_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void)?,
        processClosure: ((_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void)?
    ) {
        self.prepareClosure = prepareClosure
        self.willSendClosure = willSendClosure
        self.didReceiveClosure = didReceiveClosure
        self.processClosure = processClosure
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        prepareClosure?(request, target)
        return request
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        willSendClosure?(request, target)
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        didReceiveClosure?(result, target)
    }

    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        processClosure?(result, target)
        return result
    }

}
