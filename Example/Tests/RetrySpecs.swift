//
//  RetrySpecs.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import APIKit
import PromiseKit
import Moya

class RetrySpecs: QuickSpec {

    var error: Error?
    var retryProfile: RetryProfile?

    override func spec() {

        beforeEach {
            retryHandshakeCount = 0
            self.error = nil
            self.retryProfile = nil
        }

        context("Decoding a Test User Profile") {
            it("should retry 3 time and fail error of type NetworkClientError") {
                var isPromiseResolved: Bool = false

                let evaluate: (() -> Void) -> Void = { done in
                    expect(retryHandshakeCount).to(equal(3))
                    expect(self.retryProfile).to(beNil())
                    expect(self.error).toNot(beNil())
                    expect(self.error).to(beAKindOf(API.NetworkClientError.self))
                    expect(isPromiseResolved).to(be(true))

                    if let error = self.error, case API.NetworkClientError.statucCodeError(error: let me) = error {
                        expect(me).to(beAKindOf(MoyaError.self))
                    } else {
                        fail("error inside status code error should be MoyaError")
                    }

                    done()
                }

                waitUntil(timeout: 10, action: { done in
                    API.retryClient.request(TestRequest.Users.RetryGetProfile(userID: "ya"))
                    .done({ response in
                        self.retryProfile = response
                    })
                    .ensure {
                        isPromiseResolved = true
                    }
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
