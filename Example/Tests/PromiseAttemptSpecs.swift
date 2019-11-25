//
//  PromiseAttemptSpecs.swift
//  APIKit_Example
//
//  Created by David on 2019/11/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import APIKit
import PromiseKit

class PromiseAttemptSpecs: QuickSpec {

    override func spec() {

        beforeEach {
            failHandShack = 0
            successHandShack = 0
        }

        context("To test promise attemp") {

            it("should retry 5 time then fail") {
                waitUntil(timeout: 10, action: { done in
                    attempt(maximumRetryCount: 5, delayBeforeRetry: .seconds(1), {
                        promiseWillFail()
                    })
                    .done({
                        fail("this promise should not succeed")
                    })
                    .catch({ e in
                        expect(failHandShack).to(equal(5))
                        done()
                    })
                })
            }

//            RepeatBehavior.

        }

    }

}

fileprivate var failHandShack: Int = 0
fileprivate var successHandShack: Int = 0

fileprivate func promiseWillFail() -> Promise<Void> {
    return Promise { seal in
        print("failing promise")
        failHandShack += 1
        seal.reject(NSError(domain: "", code: -1, userInfo: nil))
    }
}

fileprivate func promiseWillSuccess() -> Promise<Void> {
    return Promise { seal in
        successHandShack += 1
        seal.fulfill(())
    }
}
