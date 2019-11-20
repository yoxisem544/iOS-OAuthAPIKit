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

var accessToken: String = "Not_change_yet"

extension API {
    public static let sharedd: NetworkClient = {
        let r = RefreshTokenPlugin(
            checkRefreshTokenValidLengthClosure: {
                return true
            },
            triggerRefreshClosure: { response in
                return true
            },
            refreshRequest: SampleReqeust.Auth.RefreshAccessToken(),
            successToRefreshClosure: { json in accessToken += "after refresh" },
            failToRefreshClosure: { error in }
        )
        let headerInjectingPlugin = HeaderInjectingPlugin(headerClosure: { target in
            return ["x-auth-token": API.config.xAuthToken]
        })
        let plugins: [PluginType] = [
            NetworkTrafficPlugin.init(indicators: .start, .done),
            headerInjectingPlugin,
            r,
            AccessTokenProvidingPlugin(tokenClosure: {
                return accessToken
            })
        ]
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)
        let client = NetworkClient(provider: provider)
        r.networkClientRef = client
        return client
    }()
}

extension API {
    static var config: Config = .bin

    enum Config {
        case `default`, staging, staging_04, bin

        var baseURL: URL {
            switch self {
            case .default: return URL(string: "https://google.com")!
            case .staging: return URL(string: "https://staging.google.com")!
            case .staging_04: return URL(string: "https://staging-04.google.com")!
            case .bin: return URL(string: "http://httpbin.org/")!
            }
        }

        var xAuthToken: String {
            switch self {
            case .default: return "ya"
            case .staging: return "ya-staging-2"
            case .staging_04: return "ya-staging-04"
            case .bin: return "bb-bin"
            }
        }
    }
}
