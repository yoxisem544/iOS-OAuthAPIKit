//
//  MockResponseSPecs.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
//import APIKit
import PromiseKit
import Moya

@testable import APIKit

class MockResponseSpecs: QuickSpec {

    override func spec() {

        beforeEach {

        }

        describe("Mocking Moya Response") {
            context("Decoding to JSON") {
                it("should successfully parse a empty json without throwing error") {
                    let mockJSON = "{}".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)
                    do {
                        _ = try response.decodeToJSON()
                        _ = succeed()
                    } catch {
                        fail("Decoding json should always success")
                    }
                }

                it("should fail to decode json if Data is empty") {
                    let mockJSON = "".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)
                    do {
                        _ = try response.decodeToJSON()
                        fail("decoding a empty json not getting an error!! Should be an error here")
                    } catch {
                        _ = succeed()
                    }
                }

                context("Decoding to Mappable") {}
                context("Decoding to ImmutableMappable") {}
                context("Decoding to Decodable") {}
            }
        }

        describe("Mocking Moya Response with Promise") {
            context("Decoding to JSON") {
                it("should successfully parse a empty json without throwing error") {
                    let mockJSON = "{}".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 5, action: { done in
                        Promise.value(response)
                        .decodeToJSON()
                        .done({ json in
                            done()
                        })
                        .catch({ e in
                            fail("should not get an error, parsing {} JSON should always succeed.")
                            done()
                        })
                    })
                }

                it("should fail to decode json if Data is empty") {
                    let mockJSON = "".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 5, action: { done in
                        Promise.value(response)
                        .decodeToJSON()
                        .done({ json in
                            fail("should not get an error, parsing empty JSON should NEVER succeed.")
                            done()
                        })
                        .catch({ e in
                            expect(e).to(beAKindOf(API.NetworkClientError.self))
                            if case API.NetworkClientError.decodingError(error: _) = e {
                                _ = succeed()
                            } else {
                                fail("this error should be a decoding error")
                            }
                            done()
                        })
                    })
                }
            }

            context("Decoding to Mappable") {

            }

            context("Decoding to ImmutableMappable") {

            }

            context("Decoding to Decodable") {

            }
        }

        describe("Mocking Moya Response with RxSwift") {
            context("Decoding to JSON") {}
            context("Decoding to Mappable") {}
            context("Decoding to ImmutableMappable") {}
            context("Decoding to Decodable") {}
        }

    }

}
