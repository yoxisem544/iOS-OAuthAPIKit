//
//  BaseRequestType.swift
//  APIKit
//
//  Created by David on 2019/11/18.
//

import Moya

/// A base request type if you do not want to use TargetType directly
/// `BaseRequestType` provides some default value and parameter property.
public protocol BaseRequestType: TargetType {
    var parameters: [String: Any] { get }
}

public extension BaseRequestType {
    var headers: [String: String]? { return nil }
    var sampleData: Data { return Data() }
    var parameters: [String: Any] { return [:] }
}
