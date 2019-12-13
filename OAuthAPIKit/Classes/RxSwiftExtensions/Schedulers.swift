//
//  Schedulers.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/29.
//

import RxSwift

internal let decodingScheduler = ConcurrentDispatchQueueScheduler(queue: decodingQueue)
