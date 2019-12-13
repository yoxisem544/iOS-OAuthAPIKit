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
import Mapper
import RxSwift

@testable import APIKit

class MockResponseSpecs: QuickSpec {

    var disposeBag: DisposeBag!

    override func spec() {

        beforeEach {
            self.disposeBag = DisposeBag()
        }

        // MARK: - Testing Plain JSON Parsing

        context("Testing JSON parsing") {
            it("should successfully decode when json is ok") {

            }

            it("should successfully parse a empty json without throwing error") {
                let mockJSON = "{}".data(using: .utf8)!
                let response = Response(statusCode: 200, data: mockJSON)
                do {
                    _ = try response.decodeToJSON()
                    _ = succeed()
                } catch {
                    fail("should not get an error, parsing {} JSON should always succeed.")
                }
            }

            it("should fail to decode json if Data is empty") {
                let mockJSON = "".data(using: .utf8)!
                let response = Response(statusCode: 200, data: mockJSON)
                do {
                    _ = try response.decodeToJSON()
                    fail("should not get an error, parsing empty JSON should NEVER succeed.")
                } catch {
                    expect(error).to(beAKindOf(API.NetworkClientError.self))
                    if case API.NetworkClientError.decodingError(error: _) = error {
                        _ = succeed()
                    } else {
                        fail("this error should be a decoding error")
                    }
                }
            }
        }

        // MARK: - Testing Reponse parsing

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
                            if case API.NetworkClientError.decodingError(error: let e) = error {
                                if case MoyaError.underlying(let uuu, _) = e {
                                    if let underlyingError = uuu as? MapperError {
                                        switch underlyingError {
                                        case .convertibleError(value: let value, type: let type):
                                            _ = succeed()
                                        default:
                                            fail("should only be convertible error")
                                        }
                                    } else {
                                        fail("should be a Mapper underlying error")
                                    }

//                                    expect(e.key).to(equal("age")) // age should be Int but get String instead
//                                    expect(e.currentValue).to(beAKindOf(String.self))
                                } else {
                                    fail("should get an Moya underlying error here")
                                }
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }
                }

                context("Decoding to Decodable") {
                    it("should successfully decode when json is ok") {
                        let mockJSON = sampleMappableObjectNormalMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleDecodableObject.self)
                            _ = succeed()
                        } catch {
                            fail("should not get a error if json is valid for decoding")
                        }
                    }

                    it("should fail to decode if JSON is corrupted.") {
                        let mockJSON = sampleMappableObjectCorruptMockData
                        let response = Response(statusCode: 200, data: mockJSON)
                        do {
                            _ = try response.decode(to: SampleDecodableObject.self)
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
                            _ = try response.decode(to: SampleDecodableObject.self)
                            fail("When encounter a corrupted JSON, you should get an error when decoding")
                        } catch {
                            if case API.NetworkClientError.decodingError(error: let e) = error {
                                if case MoyaError.objectMapping(let mappingError, _) = e {
                                    expect(mappingError).to(beAKindOf(DecodingError.self))
                                    _ = succeed()
                                } else {
                                    fail("should get an ObjectMapper MapError struct here")
                                }
                            } else {
                                fail("Error should be decoding error!")
                            }
                        }
                    }
                }
            }
        }

        describe("Mocking Moya Response with Promise") {
            context("Decoding to JSON") {
                it("should just success") {
                    let mockJSON = "{}".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 3, action: { done in
                        Promise.value(response)
                            .decodeToJSON()
                            .done({ json in
                                _ = succeed()
                                done()
                            })
                            .catch({ e in
                                fail("parsing an empty json should never fail")
                            })
                    })
                }
            }

            context("Decoding to Mappable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 3, action: { done in
                        Promise.value(response)
                            .decode(to: SampleMappableObject.self)
                            .done({ json in
                                _ = succeed()
                                done()
                            })
                            .catch({ e in
                                fail("parsing an empty json should never fail")
                            })
                    })
                }
            }

            context("Decoding to ImmutableMappable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 3, action: { done in
                        Promise.value(response)
                            .decode(to: SampleMappableObject.self)
                            .done({ json in
                                _ = succeed()
                                done()
                            })
                            .catch({ e in
                                fail("parsing an empty json should never fail")
                            })
                    })
                }
            }

            context("Decoding to Decodable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)
                    waitUntil(timeout: 3, action: { done in
                        Promise.value(response)
                            .decode(to: SampleDecodableObject.self)
                            .done({ json in
                                _ = succeed()
                                done()
                            })
                            .catch({ e in
                                fail("parsing an empty json should never fail")
                            })
                    })
                }
            }
        }

        describe("Mocking Moya Response with Single") {
            context("Decoding to JSON") {
                it("should just success") {
                    let mockJSON = "{}".data(using: .utf8)!
                    let response = Response(statusCode: 200, data: mockJSON)

                    waitUntil(timeout: 3, action: { done in
                        Single.just(response)
                            .decodeToJSON()
                            .subscribe(onSuccess: { json in
                                _ = succeed()
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }
            }

            context("Decoding to Mappable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)

                    waitUntil(timeout: 3, action: { done in
                        Single.just(response)
                            .decode(to: SampleMappableObject.self)
                            .subscribe(onSuccess: { json in
                                _ = succeed()
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }
            }

            context("Decoding to ImmutableMappable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)

                    waitUntil(timeout: 3, action: { done in
                        Single.just(response)
                            .decode(to: SampleMappableObject.self)
                            .subscribe(onSuccess: { json in
                                _ = succeed()
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }
            }

            context("Decoding to Decodable") {
                it("should just success") {
                    let mockJSON = sampleMappableObjectNormalMockData
                    let response = Response(statusCode: 200, data: mockJSON)

                    waitUntil(timeout: 3, action: { done in
                        Single.just(response)
                            .decode(to: SampleDecodableObject.self)
                            .subscribe(onSuccess: { json in
                                _ = succeed()
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }
            }
        }

    }

}

// MARK: - Mock data

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
    let name: String
    let id: String
    let age: Int

    init(map: Mapper) throws {
        name = try map.from("name")
        id = try map.from("id")
        age = try map.from("age")
    }
}

fileprivate struct SampleDecodableObject: Decodable {
    let name: String
    let id: String
    let age: Int

    enum CodingKeys: String, CodingKey {
        case name, id, age
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        age = try container.decode(Int.self, forKey: .age)
    }
}
