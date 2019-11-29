//
//  Threads.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/29.
//

import Foundation
import RxSwift

/// Thread to separate api call from which will be suspended.
internal let authRequestQueue = DispatchQueue(label: "io.api.network_client.auth_request_queue")

/// Thread for decoding
internal let decodingQueue = DispatchQueue(
    label: "io.api.network_response_decoding_queue.concurrent",
    qos: .userInitiated,
    attributes: .concurrent
)

internal let decodingScheduler = ConcurrentDispatchQueueScheduler(queue: decodingQueue)
