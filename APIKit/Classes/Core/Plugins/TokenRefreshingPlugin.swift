//
//  TokenRefreshingPlugin.swift
//  SCM-iOS APP
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 KKday. All rights reserved.
//

import Foundation
import Moya
import Result

public class TokenRefreshingPlugin: PluginType {

    private var credential: Credential? { return nil }
    public var networkClientRef: API.NetworkClient?

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            if response.statusCode == 403 {
                guard let credential = credential else { return }
                // 1. stop network client
                networkClientRef?.blockRequestQueue()
                // 2. refresh access token
                // TODO: if refresh token api is ready, fix this.
//                networkClientRef?.request(KKdaySCMRequest.RefreshToken(credential: credential))
//                    .done({ response in
//                        // 3. store response to credential manager
//                        // TODO: store credential after token has refreshed
//                    })
//                    .ensure({
//                        // 4. always release blocked request queue
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: { // simulate refreshing for 10 seconds
//                            self.networkClientRef?.releaseRequestQueue()
//                        })
//                    })
//                    .catch({ e in
//                        // 5. handle error if refresh failed, if request has failed, should log out user
//                    })
            }
        case let .failure(error):
            // get an error, might be network timeout issue, no need to logout user
            print(error)
        }
    }

}

