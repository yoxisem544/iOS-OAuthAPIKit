//
//  HeaderInjectingPlugin.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya

/// Requests conforms to HeaderInjecting will be inject with given header before sending requests
public protocol HeaderInjecting {}

/// HeaderInjectingPlugin can help you inject some header fields before sending requests.
public class HeaderInjectingPlugin : PluginType {

    /// You can provide HTTP header by passing a string dictionary in this closure.
    public let headerClosure: ((TargetType) -> [String: String])

    public init(headerClosure: @escaping ((TargetType) -> [String: String])) {
        self.headerClosure = headerClosure
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        let actualTarget: TargetType = {
            if let multiTarget = target as? MultiTarget, case let MultiTarget.target(actualTarget) = multiTarget {
                return actualTarget
            } else {
                return target
            }
        }()

        var request = request
        for (key, value) in headerClosure(actualTarget) {
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }

}

