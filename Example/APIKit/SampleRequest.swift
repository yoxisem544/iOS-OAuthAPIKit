//
//  SampleRequest.swift
//  APIKit_Example
//
//  Created by David on 2019/11/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import APIKit
import Moya

public protocol SampleRequestType: BaseRequestType {}

extension SampleRequestType {
    public var baseURL: URL { URL(string: "https://google.com")! }
    public var headers: [String : String]? { [:] }
    public var sampleData: Data { Data() }
    public var parameters: [String : Any] { [:] }
}

public struct SampleReqeust {}

extension API {
    public static let sharedd: NetworkClient = {
        let xAuthHeaderInjectingPlugin = XAuthHeaderInjectingPlugin(xAuthHeaderClosure: { target in
            return "soaidjoiajsdiojasiojdoij2198u319283u9128uew9i1298eu"
        })
        let plugins: [PluginType] = [
            NetworkTrafficPlugin.init(indicatorType: .start, .done),
            xAuthHeaderInjectingPlugin,
        ]
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        let client = NetworkClient(provider: provider)
        return client
    }()
}
