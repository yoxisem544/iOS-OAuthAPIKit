//
//  Threads.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/29.
//

import Foundation

/// Thread to separate api call from which will be suspended.
internal let nonBlockingRequestQueue = DispatchQueue(label: "io.api.network_client.nonblocking_request_queue")

/// Thread for decoding
internal let decodingQueue = DispatchQueue(
    label: "io.api.network_response_decoding_queue.concurrent",
    qos: .userInitiated,
    attributes: .concurrent
)
