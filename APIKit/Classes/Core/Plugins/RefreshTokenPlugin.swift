//
//  RefreshTokenPlugin.swift
//  APIKit
//
//  Created by David on 2019/11/18.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

public class RefreshTokenPlugin<Target: TargetType & AuthRequest>: PluginType {

    // MARK: - Properties

    public var networkClientRef: API.NetworkClient?
    private let checkRefreshTokenValidLengthClosure: (() -> Bool)
    private let triggerRefreshClosure: ((Response) -> Bool)
    private var isRefreshing: Bool {
        didSet {
            isRefreshing ? networkClientRef?.blockRequestQueue() : networkClientRef?.releaseRequestQueue()
        }
    }
    private let refreshRequest: Target
    private let successToRefreshClosure: ((JSON) -> Void)
    private let failToRefreshClosure: ((Error) -> Void)

    // MARK: - Initialization

    public init(
        checkRefreshTokenValidLengthClosure: @escaping (() -> Bool),
        triggerRefreshClosure: @escaping ((Response) -> Bool),
        refreshRequest: Target,
        successToRefreshClosure: @escaping ((JSON) -> Void),
        failToRefreshClosure: @escaping ((Error) -> Void)
    ) {
        self.checkRefreshTokenValidLengthClosure = checkRefreshTokenValidLengthClosure
        self.triggerRefreshClosure = triggerRefreshClosure
        self.isRefreshing = false
        self.refreshRequest = refreshRequest
        self.successToRefreshClosure = successToRefreshClosure
        self.failToRefreshClosure = failToRefreshClosure
    }

    // MARK: - To check token valid time before sending requests
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard !(target is AuthRequest) else { return request } // ignore auth request

        if checkRefreshTokenValidLengthClosure() {
            performRefresh()
        }

        return request
    }

    // MARK: - When receive 403 or 401 unauthurized error code

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard !(target is AuthRequest) else { return } // ignore auth request

        switch result {
        case .success(let response):
            if triggerRefreshClosure(response) {
                performRefresh()
            }
        case .failure:
            // get an error, might be network timeout issue, no need to logout user
            return
        }
    }

    // MARK: - Methods

    private func performRefresh() {
        guard networkClientRef != nil else {
            assertionFailure("you should assing a network client ref!!")
            return
        }
        // if token has just been refreshed,
        // will have 60 seconds to trust this access token and refresh token to be valid.
        // in 60 second range, all refresh will be just ignored.
        if shouldTrustLastRefreshRequest() { return }

        if !isRefreshing {
            // 1. stop network client
            isRefreshing = true
            // 2. refresh access token
            networkClientRef?.request(refreshRequest)
                // 3. store response to credential manager
                .done({ json in
                    self.lastRefreshTime = Date()
                    self.successToRefreshClosure(json)
                })
                // 4. always release blocked request queue
                .ensure({ self.isRefreshing = false })
                // 5. handle error if refresh failed, if request has failed, should log out user
                .catch({ e in self.failToRefreshClosure(e) })
        }
    }

    // MARK: - refresh trust policy

    private var lastRefreshTime: Date?
    private let refreshTrustTime: TimeInterval = 60

    private func timeSinceLastRefreshTime() -> TimeInterval? {
        guard let lastRefreshTime = lastRefreshTime else { return nil }
        return (Date().timeIntervalSince1970 - lastRefreshTime.timeIntervalSince1970)
    }

    private func shouldTrustLastRefreshRequest() -> Bool {
        if let timeSinceLastRefreshTime = timeSinceLastRefreshTime(), (timeSinceLastRefreshTime < refreshTrustTime) {
            // just refreshed!
            return true
        } else {
            // not refreshed yet
            return false
        }
    }

}

