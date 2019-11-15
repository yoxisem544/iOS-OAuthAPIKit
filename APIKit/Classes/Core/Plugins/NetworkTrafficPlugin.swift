//
//  NetworkTrafficPlugin.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Result

public class NetworkTrafficPlugin: PluginType {

    public enum IndicatorType: CaseIterable {
        case start, done
    }

    private let indicatorType: [IndicatorType]

    public init(indicatorType: IndicatorType...) {
        self.indicatorType = indicatorType
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        guard indicatorType.contains(.start) else { return }

        let requestURL = request.request?.url?.absoluteString ?? ""
        print("🔶==================================================================================")
        print("🔆 request starting 🔗 \(requestURL)")
        print("📩 header \(request.request?.allHTTPHeaderFields)")

        switch target.task {
        case let .requestParameters(parameters: pms, encoding: encoding):
            print("🎁 request with parameters! encoding -> \(encoding)")
            print("\(pms)")
            print("🔶==================================================================================")
        default: break
        }
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard indicatorType.contains(.done) else { return }

        print("❕ Request finished =======================================================")

        switch result {
        case let .success(response):
            let url = response.request?.url?.absoluteString ?? ""
            print("request 🔗 \(url) done!")
            print("status code: \(response.statusCode)")
            print("response json: \n\(try? JSON(data: response.data))")
        case let .failure(error):
            let url = error.response?.request?.url?.absoluteString ?? ""
            print("request 🔗 \(url) failed!")
            print("status code: \(error.response?.statusCode)")
            print("error response: \n\(try? error.response?.mapString())")
        }

        print("❕========================================================================")
    }

}

