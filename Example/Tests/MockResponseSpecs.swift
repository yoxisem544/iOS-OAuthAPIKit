//
//  MockResponseSpecs.swift
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
import ObjectMapper

@testable import APIKit

fileprivate let sampleMappableObjectNormalMockData = """
{
    "name": "Johnny Appleseed",
    "id": "xjois210912",
    "age": 100,
}
""".data(using: .utf8)!

fileprivate let sampleMappableObjectCorruptMockData = """
{
    "name": "Johnny Appleseed,
    "id": "xjois210912",
    "age": 0,
}
""".data(using: .utf8)!

fileprivate let sampleMappableObjectIncorrectAgeMockData = """
{
    "name": "Johnny Appleseed",
    "id": "xjois210912",
    "age": "0",
}
""".data(using: .utf8)!

fileprivate struct SampleMappableObject: Mappable {
    var name: String?
    var id: String?
    var age: Int = 0

    init?(map: Map) {
        guard let age = map.JSON["age"] as? Int else { return nil } // user must have a age
        guard age > 0 else { return nil } // fail when age is smaller than 0
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        age <- map["age"]
    }
}

fileprivate struct SampleImmutableMappableObject: ImmutableMappable {
    let name: String
    let id: String
    let age: Int

    init(map: Map) throws {
        name = try map.value("name")
        id = try map.value("id")
        age = try map.value("age")
    }
}

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

                context("Decoding to Mappable") {
                    it("should successfully decode when json is ok") {
                        let mockJSON = sampleMappableObjectNormalMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleMappableObject.self)
                            _ = succeed()
                        } catch {
                            fail("should not get a error if json is valid for decoding")
                        }
                    }

                    it("should fail to decode if JSON is corrupted.") {
                        let mockJSON = sampleMappableObjectCorruptMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleMappableObject.self)
                            fail("When encounter a corrupted JSON, you should get an error when decoding")
                        } catch {
                            if case API.NetworkClientError.decodingError = error {
                                _ = succeed()
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }

                    it("should fail to decode if age is incorrect.") {
                        let mockJSON = sampleMappableObjectIncorrectAgeMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleMappableObject.self)
                            fail("When encounter a corrupted JSON, you should get an error when decoding")
                        } catch {
                            if case API.NetworkClientError.decodingError = error {
                                _ = succeed()
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }
                }

                context("Decoding to ImmutableMappable") {
                    it("should successfully decode when json is ok") {
                        let mockJSON = sampleMappableObjectNormalMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleImmutableMappableObject.self)
                            _ = succeed()
                        } catch {
                            fail("should not get a error if json is valid for decoding")
                        }
                    }

                    it("should fail to decode if JSON is corrupted.") {
                        let mockJSON = sampleMappableObjectCorruptMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleImmutableMappableObject.self)
                            fail("When encounter a corrupted JSON, you should get an error when decoding")
                        } catch {
                            if case API.NetworkClientError.decodingError = error {
                                _ = succeed()
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }

                    it("should fail to decode if age is incorrect.") {
                        let mockJSON = sampleMappableObjectIncorrectAgeMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleImmutableMappableObject.self)
                            fail("When encounter a corrupted JSON, you should get an error when decoding")
                        } catch {
                            if case API.NetworkClientError.decodingError(error: let e) = error {
                                if let e = e as? ObjectMapper.MapError {
                                    expect(e.key).to(equal("age")) // age should be Int but get String instead
                                    expect(e.currentValue).to(beAKindOf(String.self))
                                } else {
                                    fail("should get an ObjectMapper MapError struct here")
                                }
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }
                }

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
