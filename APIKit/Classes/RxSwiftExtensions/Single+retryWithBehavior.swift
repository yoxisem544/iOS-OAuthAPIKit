//
//  Singel+retryWithBehavior.swift
//  APIKit
//
//  Created by David on 2019/9/2.
//  Copyright © 2019 David. All rights reserved.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {

    /**
     Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
     - parameter behavior: Behavior that will be used in case of an error
     - parameter scheduler: Schedular that will be used for delaying subscription after error
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Observable sequence that will be automatically repeat if error occurred
     */
    public func retry(_ behavior: RepeatBehavior, scheduler: SchedulerType = MainScheduler.instance, shouldRetry: RetryPredicate? = nil) -> Single<Element> {
        return retry(1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
    }

    /**
     Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
     - parameter currentAttempt: Number of current attempt
     - parameter behavior: Behavior that will be used in case of an error
     - parameter scheduler: Schedular that will be used for delaying subscription after error
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Observable sequence that will be automatically repeat if error occurred
     */
    internal func retry(_ currentAttempt: UInt, behavior: RepeatBehavior, scheduler: SchedulerType = MainScheduler.instance, shouldRetry: RetryPredicate? = nil) -> Single<Element> {
        guard currentAttempt > 0 else { return Single.error(RetryWithBehaviorError.currentAttemptInvalid) }

        // calculate conditions for bahavior
        let conditions = behavior.calculateConditions(currentAttempt)

        return catchError({ error -> Single<Element> in
            // return error if exceeds maximum amount of retries
            guard conditions.maxCount > currentAttempt else { return Single.error(error) }

            if let shouldRetry = shouldRetry, !shouldRetry(error) {
                // also return error if predicate says so
                return Single.error(error)
            }

            guard conditions.delay != .never else {
                // if there is no delay, simply retry
                return self.retry(currentAttempt + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
            }

            // otherwise retry after specified delay
            return Single<Void>.just(()).delaySubscription(conditions.delay.toDoubleValue(), scheduler: scheduler).flatMap({
                self.retry(currentAttempt + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
            })
        })
    }
}
