//
//  API+Stubbing.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya

extension API {

    public struct StubbingConstructor {

        /// Default stubing status code is 200
        private var statusCode: Int = 200

        /// Default to return a empty data
        private var mockData: Data = Data()

        /// default response time will be set to 0.3 second after network request has performed
        private var responseTime: TimeInterval = 0.3

        /// Set success stubbing condition.
        ///
        /// - Parameters:
        ///   - mockData: mock data for stubbing
        ///   - statusCode: fake status code
        ///   - responseTime: response time of stubbing request
        public func setSuccess(mockData: Data, statusCode: Int = 200, responseTime: TimeInterval = 0.3) -> NetworkClient {
            return NetworkClient(provider: {
                let mockDataClosure = makeMockDataClosure(statusCode, mockData)
                let stubClosure = getStubClosure(from: responseTime)
                return MoyaProvider<MultiTarget>(endpointClosure: mockDataClosure, stubClosure: stubClosure)
            }())
        }

        /// Set fail stubbing condition.
        ///
        /// - Parameters:
        ///   - mockData: mock data for stubbing
        ///   - statusCode: fake status code
        ///   - responseTime: response time of stubbing request
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

