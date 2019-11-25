//
//  RequestGetterSpecs.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import ObjectMapper

@testable import APIKit

class RequestGetterSpecs: QuickSpec {

    fileprivate let request = JustATestRequest()

    override func spec() {

        context("To see if request is able to return correct info") {

            it("should get a base url") {
                expect(self.request.baseURL.absoluteString) == "https://google.com"
            }

            it("should get a path") {
                expect(self.request.path) == "dont/even/care/path"
            }

            it("should get a http method of GET") {
                expect(self.request.method) == .get
            }

            it("should be a retry request") {
                expect(self.request).to(beAKindOf(RetryableRquest.self))
            }

        }

    }

}

fileprivate protocol JustATestRequestType: BaseRequestType {}

extension JustATestRequestType {
    var baseURL: URL { return URL(string: "https://google.com")! }
}

fileprivate struct JustATestRequest: JustATestRequestType, RetryableRquest, ImmutableMappableResponse {
    typealias ResponseType = Ya

    var path: String { return "dont/even/care/path" }
    var method: APIKit.Method { return .get }
    var task: Task { return .requestPlain }
    var retryBehavior: RepeatBehavior { return .exponentialDelayed(maxCount: 100, initial: 1, multiplier: 1.01) }
}

fileprivate struct Ya: ImmutableMappable {
    let name: String

    init(map: Map) throws {
        name = try map.value("name")
    }
}
