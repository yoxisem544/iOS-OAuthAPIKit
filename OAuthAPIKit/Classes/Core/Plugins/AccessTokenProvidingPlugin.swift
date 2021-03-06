//
//  AccessTokenProvidingPlugin.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/19.
//  Copyright © 2019 David. All rights reserved.
//

import Moya

// MARK: - AccessTokenAuthorizable
/// A protocol for controlling the behavior of `AccessTokenPlugin`.
public protocol HasAccessToken {}

public final class AccessTokenProvidingPlugin: PluginType {

    /// A closure returning the access token to be applied in the header.
    public let tokenClosure: () -> String

    public init(tokenClosure: @escaping () -> String) {
        self.tokenClosure = tokenClosure
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        let actualTarget: TargetType = {
            if let multiTarget = target as? MultiTarget, case let MultiTarget.target(actualTarget) = multiTarget {
                return actualTarget
            } else {
                return target
            }
        }()
        guard actualTarget is HasAccessToken else { return request }

        var request = request
        let value = "Bearer " + tokenClosure()
        request.addValue(value, forHTTPHeaderField: "Authorization")

        return request
    }

}
