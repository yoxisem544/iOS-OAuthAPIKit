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
                    attempt(maximumRetryCount: 5, delayBeforeRetry: .milliseconds(100), {
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

            it("should at least execute once when retry times is 0") {
                waitUntil(timeout: 3, action: { done in
                    attempt(maximumRetryCount: 0, delayBeforeRetry: .milliseconds(200), {
                        promiseWillFail()
                    })
                    .done({
                        fail("done will never be executed since promise will always fail")
                    })
                    .catch({ e in
                        expect(failHandShack).to(equal(1)) // attempt with 0 times will at least execute promise once.
                        done()
                    })
                })
            }

            it("should try once if retry count is 0 when using repeat behavior") {
                waitUntil(timeout: 3, action: { done in
                    attempt(RepeatBehavior.immediate(maxCount: 0), { promiseWillFail() })
                    .done({
                        fail("done will never be executed since promise will always fail")
                    })
                    .catch({ e in
                        expect(failHandShack).to(equal(1)) // attempt with 0 times will at least execute promise once.
                        done()
                    })
                })
            }

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
