//
//  RetryGotDecodingErrorSpecs.swift
//  APIKit_Example
//
//  Created by David on 2019/11/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import APIKit
import PromiseKit
import Moya

fileprivate let userMockData = """
{
    "username": "John",
    "user_id": 1239,
}
""".data(using: .utf8)!

extension TestRequest.Users {
    struct SomeRetryingRequest: TestRequestType, RetryableRquest, ImmutableMappableResponse {
        typealias ResponseType = Userr

        var path: String { return "get" }
        var method: APIKit.Method { return .get }
        var task: Task { .requestPlain }
    }
}

class RetryGotDecodingErrorSpecs: QuickSpec {

    var error: Error?
    var user: Userr?

    override func spec() {

        beforeEach {
            retryHandshakeCount = 0
            self.error = nil
            self.user = nil
        }

        context("Decoding fail on a retry request") {
            it("should only attempt once and got an decoding error") {

                let evaluate: (() -> Void) -> Void = { done in
                    expect(self.user).to(beNil())
                    expect(self.error).toNot(beNil())
                    expect(retryHandshakeCount).to(equal(1))
                    done()
                }

                waitUntil(timeout: 10, action: { done in
                    API.stubbing().setSuccess(mockData: userMockData).request(TestRequest.Users.SomeRetryingRequest())
                        .done({ user in
                            self.user = user
                            evaluate(done)
                        })
                        .catch({ e in
                            self.error = e
                            evaluate(done)
                        })
                })
            }
        }
    }

}

fileprivate var retryHandshakeCount: Int = 0

fileprivate extension API {
    static let retryClient: NetworkClient = {
        let t = NetworkTraffic2Plugin(
            prepareClosure: { r, t in print("✈️prepareClosure") },
            willSendClosure: { r, t in print("✈️willSendClosure"); retryHandshakeCount += 1 },
            didReceiveClosure: { r, t in print("✈️didReceiveClosure") },
            processClosure: { r, t in print("✈️processClosure") }
        )
        let plugins: [PluginType] = [
            t
        ]
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        let client = NetworkClient(provider: provider)
        return client
    }()
}
