//
//  ErrorDecodingSpecs.swift
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

class ErrorDecodingSpecs: QuickSpec {

    var error: Error?
    var user: Userr?

    override func spec() {

        beforeEach {
            self.error = nil
            self.user = nil
        }

        it("should fail on decoding user model") {
            API.stubbing()
                .setSuccess(mockData: userMockData, statusCode: 200, responseTime: 0)
                .request(TestRequest.Users.SomeRetryingRequest())
                .done({ user in
                    self.user = user
                })
                .catch({ e in
                    self.error = e
                })

            expect(self.user).toEventually(beNil(), timeout: 3, pollInterval: 1)
            expect(self.error).toEventuallyNot(beNil(), timeout: 3, pollInterval: 1)
        }
    }

}
