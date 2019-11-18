//
//  RefreshTokenPlugin.swift
//  APIKit
//
//  Created by David on 2019/11/18.
//

import Moya
import Result
import SwiftyJSON

public class RefreshTokenPlugin<Target: TargetType>: PluginType {

    public var networkClientRef: API.NetworkClient?
    private let triggerRefreshClosure: ((Response) -> Bool)
    private var isRefreshing: Bool {
        didSet {
            isRefreshing ? networkClientRef?.blockRequestQueue() : networkClientRef?.releaseRequestQueue()
        }
    }
    private let refreshRequest: Target
    private let successToRefreshClosure: ((JSON) -> Void)
    private let failToRefreshClosure: ((Error) -> Void)

    public init(
        triggerRefreshClosure: @escaping ((Response) -> Bool),
        refreshRequest: Target,
        successToRefreshClosure: @escaping ((JSON) -> Void),
        failToRefreshClosure: @escaping ((Error) -> Void)
    ) {
        self.triggerRefreshClosure = triggerRefreshClosure
        self.isRefreshing = false
        self.refreshRequest = refreshRequest
        self.successToRefreshClosure = successToRefreshClosure
        self.failToRefreshClosure = failToRefreshClosure
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            if triggerRefreshClosure(response) {
                if !isRefreshing {
                    // 1. stop network client
                    isRefreshing = true
                    // 2. refresh access token
                    networkClientRef?.request(refreshRequest)
                        // 3. store response to credential manager
                        .done({ json in self.successToRefreshClosure(json) })
                        // 4. always release blocked request queue
                        .ensure({ self.isRefreshing = false })
                        // 5. handle error if refresh failed, if request has failed, should log out user
                        .catch({ e in self.failToRefreshClosure(e) })
                }
            }
        case let .failure(error):
            // get an error, might be network timeout issue, no need to logout user
            print(error)
        }
    }

}

