//
//  HeaderInjectingPlugin.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya

public protocol HeaderInjecting {}

public class HeaderInjectingPlugin : PluginType {

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

