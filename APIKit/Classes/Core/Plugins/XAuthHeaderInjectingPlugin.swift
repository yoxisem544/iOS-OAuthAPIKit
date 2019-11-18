//
//  XAuthHeaderInjectingPlugin.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya

public protocol XAuthHeaderInjecting {}

public class XAuthHeaderInjectingPlugin : PluginType {

    public let xAuthHeaderClosure: ((TargetType) -> String)

    public init(xAuthHeaderClosure: @escaping ((TargetType) -> String)) {
        self.xAuthHeaderClosure = xAuthHeaderClosure
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
        let value = xAuthHeaderClosure(actualTarget)
        request.addValue(value, forHTTPHeaderField: "x-auth-token")

        return request
    }

}

