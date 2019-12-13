//
//  BaseRequestType.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/18.
//

import Moya

public typealias HTTPMethod = Moya.Method

/// A base request type if you do not want to use TargetType directly
/// `BaseRequestType` provides some default value and parameter property.
public protocol BaseRequestType: TargetType {
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
}

public extension BaseRequestType {
    var headers: [String: String]? { return nil }
    var sampleData: Data { return Data() }
    var parameters: [String: Any] { return [:] }
}
