//
//  TestRequests.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import APIKit
import Moya

public protocol TestRequestType: BaseRequestType {}

extension TestRequestType {
    public var baseURL: URL { return URL(string: "http://httpbin.org")! }
}

public struct TestRequest {}

extension TestRequest {

    struct Users {
        struct GetProfile: TestRequestType, MappableResponse {
            typealias ResponseType = Userr
            
            var path: String { return "get" }
            var method: APIKit.Method { return .get }
            var task: Task { return .requestPlain }

            let userID: String
            init(userID: String) {
                self.userID = userID
            }
        }

        struct RetryGetProfile: TestRequestType, MappableResponse, RetryableRquest {
            typealias ResponseType = RetryProfile
            
            var retryBehavior: RepeatBehavior { return .delayed(maxCount: 3, time: 0.1) }
            var path: String { return "post22" }
            var method: APIKit.Method { return .post }
            var parameters: [String : Any] {
                return [
                    "info": "yo info",
                    "username": "fake name",
                ]
            }
            var task: Task { return .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

            let userID: String
            init(userID: String) {
                self.userID = userID
            }
        }
    }

}
