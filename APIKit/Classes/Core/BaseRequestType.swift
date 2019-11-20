//
//  BaseRequestType.swift
//  APIKit
//
//  Created by David on 2019/11/18.
//

import Moya

public protocol BaseRequestType: TargetType {
    var parameters: [String : Any] { get }
}

public extension BaseRequestType {
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    var parameters: [String : Any] { [:] }
}
