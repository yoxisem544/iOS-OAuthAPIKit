//
//  Promise+Attempt.swift
//  APIKit
//
//  Created by David on 2019/8/29.
//  Copyright © 2019 David. All rights reserved.
//

import PromiseKit

func attempt<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
    var attempts = 0
    func attempt() -> Promise<T> {
        attempts += 1
        return body().recover { error -> Promise<T> in
            guard attempts < maximumRetryCount else { throw error }
            return after(delayBeforeRetry).then(on: nil, attempt)
        }
    }
    return attempt()
}

func attempt<T>(_ behavior: RepeatBehavior, _ body: @escaping () -> Promise<T>) -> Promise<T> {
    var attempts: UInt = 0
    func attempt() -> Promise<T> {
        attempts += 1
        return body().recover({ error -> Promise<T> in
            let (maxCount, delay) = behavior.calculateConditions(attempts)
            print("retry time \(delay)")
            guard attempts < maxCount else { throw error }
            return after(delay).then(on: nil, attempt)
        })
    }
    return attempt()
}
