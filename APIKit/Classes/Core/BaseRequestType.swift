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
