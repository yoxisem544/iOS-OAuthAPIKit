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
        struct GetYA: SampleRequestType, XAuthHeaderInjecting {
            var path: String { "yo" }
            var method: Method { .get }
            var task: Task { .requestPlain }
        }
    }
}
