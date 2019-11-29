//
//  AuthRequest.swift
//  OAuthAPIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import Moya
import PromiseKit
import SwiftyJSON

/// AuthRequest is a flag for NetworkClient to notice that
/// requests conforms to this protocol won't be suspended by refresh request
public protocol AuthRequest {}

/// Thread to separate api call from which will be suspended.
internal let authRequestQueue = DispatchQueue(label: "io.api.network_client.auth_request_queue")
