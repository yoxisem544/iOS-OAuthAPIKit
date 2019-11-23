//
//  DecodingSpecs.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import APIKit
import PromiseKit

let userMockData = """
{
    "username": "John",
    "user_id": "12398u219898u",
}
""".data(using: .utf8)!

class DecodingSpecs: QuickSpec {

    var user: User?
    var error: Error?

    override func spec() {

        beforeEach {
            self.user = nil
            self.error = nil
        }

        context("Decoding a Test User Profile") {
            it("should get a user model from a mock data") {
                API.stubbing().setSuccess(mockData: userMockData).request(TestRequest.Users.GetProfile(userID: "doesn't_matters"))
                    .done({ user in
                        self.user = user
                    })
                    .catch({ e in
                        self.error = e
                    })

                expect(self.user).toEventuallyNot(beNil())
                expect(self.user?.username).toEventually(equal("John"))
                expect(self.user?.userID).toEventually(equal("12398u219898u"))
                expect(self.error).toEventually(beNil())
            }
        }
    }
    
}
