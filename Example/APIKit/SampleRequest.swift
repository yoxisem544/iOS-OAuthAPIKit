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
    public var baseURL: URL { API.config.baseURL }
    public var headers: [String : String]? { [:] }
    public var sampleData: Data { Data() }
    public var parameters: [String : Any] { [:] }
}

public struct SampleReqeust {}

extension API {
    public static let sharedd: NetworkClient = {
        let xAuthHeaderInjectingPlugin = XAuthHeaderInjectingPlugin(xAuthHeaderClosure: { target in
            return API.config.xAuthToken
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

extension API {
    static var config: Config = .staging_04

    enum Config {
        case `default`, staging, staging_04

        var baseURL: URL {
            switch self {
            case .default: return URL(string: "https://google.com")!
            case .staging: return URL(string: "https://staging.google.com")!
            case .staging_04: return URL(string: "https://staging-04.google.com")!
            }
        }

        var xAuthToken: String {
            switch self {
            case .default: return "ya"
            case .staging: return "ya-staging-2"
            case .staging_04: return "ya-staging-04"
            }
        }
    }
}
