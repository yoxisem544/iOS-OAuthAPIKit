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

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let multiTarget = target as? MultiTarget, case let MultiTarget.target(actualTarget) = multiTarget {
            if actualTarget is (KKdaySCMRequestType & XAuthHeaderInjecting) {
                // inject x-auth header here
                var request = request // mutabable copy of request
                request.addValue(ConfigManager.shared.token, forHTTPHeaderField: "x-auth-token")
                return request
            }
        }

        return request
    }

}

