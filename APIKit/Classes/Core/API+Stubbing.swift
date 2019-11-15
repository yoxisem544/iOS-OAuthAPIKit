//
//  API+Stubbing.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya

extension API {

    public struct StubbingConstructor {
        private var statusCode: Int = 200
        private var mockData: Data = Data()
        private var responseTime: TimeInterval = 0.3

        public func setSuccess(mockData: Data, statusCode: Int = 200, responseTime: TimeInterval = 0.3) -> NetworkClient {
            return NetworkClient(provider: {
                let mockDataClosure = makeMockDataClosure(statusCode, mockData)
                let stubClosure = getStubClosure(from: responseTime)
                return MoyaProvider<MultiTarget>(endpointClosure: mockDataClosure, stubClosure: stubClosure)
            }())
        }

        public func setFailure(mockData: Data, statusCode: Int = 400, responseTime: TimeInterval = 0.3) -> NetworkClient {
            return NetworkClient(provider: {
                let mockDataClosure = makeMockDataClosure(statusCode, mockData)
                let stubClosure = getStubClosure(from: responseTime)
                return MoyaProvider<MultiTarget>(endpointClosure: mockDataClosure, stubClosure: stubClosure)
            }())
        }

        /// Determine if needs a delayed stubbing from given response time
        private func getStubClosure(from responseTime: TimeInterval) -> ((MultiTarget) -> StubBehavior) {
            return responseTime > 0 ? MoyaProvider.delayedStub(responseTime) : MoyaProvider.immediatelyStub
        }

        private func makeMockDataClosure(_ statusCode: Int, _ mockData: Data) -> ((MultiTarget) -> Endpoint) {
            return { (target: MultiTarget) -> Endpoint in
                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(statusCode, mockData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
        }

    }

    /// Starts a stubbing api call
    public class func stubbing() -> StubbingConstructor {
        return StubbingConstructor()
    }

}

