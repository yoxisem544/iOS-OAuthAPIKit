//
//  RetryableRequest.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/29.
//

import Foundation

/// For requests that needs retry behavior
public protocol RetryableRquest {
    var retryBehavior: RepeatBehavior { get }
}

public extension RetryableRquest {
    /// Default to general delay with retry count 3 times, each retry with 2 seconds interval.
    var retryBehavior: RepeatBehavior { return .delayed(maxCount: 3, time: 2) }
}
