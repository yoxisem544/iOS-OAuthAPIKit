//
//  SampleRequest+Ya.swift
//  APIKit_Example
//
//  Created by David on 2019/11/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import APIKit

extension SampleReqeust {
    struct Ya {
        struct GetYA: SampleRequestType, XAuthHeaderInjecting, HasAccessToken, RetryableRquest {
            var path: String { "/get/翁" }
            var method: Method { .get }
            var task: Task { .requestParameters(parameters: ["path": "ya/yo嗡嗡"], encoding: URLEncoding.default) }
        }
    }

    struct Auth {
        struct RefreshAccessToken: SampleRequestType, AuthRequest {
            var path: String { "/get" }
            var method: Method { .get }
            var task: Task { .requestParameters(parameters: ["path": "refresh"], encoding: URLEncoding.default) }
        }
    }
}
