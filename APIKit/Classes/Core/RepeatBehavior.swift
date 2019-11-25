//
//  RepeatBehavior.swift
//  RxSwiftExt
//
//  Created by Anton Efimenko on 17/07/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//
//  see more: https://github.com/RxSwiftCommunity/RxSwiftExt/blob/master/Source/RxSwift/retryWithBehavior.swift
import Foundation

/**
 Specifies how observable sequence will be repeated in case of an error
 - Immediate: Will be immediatelly repeated specified number of times
 - Delayed: Will be repeated after specified delay specified number of times
 - ExponentialDelayed: Will be repeated specified number of times.
 Delay will be incremented by multiplier after each iteration (multiplier = 0.5 means 50% increment)
 - CustomTimerDelayed: Will be repeated specified number of times. Delay will be calculated by custom closure
 */

public enum RepeatBehavior {
    case immediate(maxCount: UInt)
    case delayed(maxCount: UInt, time: Double)
    case exponentialDelayed(maxCount: UInt, initial: Double, multiplier: Double)
    case customTimerDelayed(maxCount: UInt, delayCalculator: (UInt) -> DispatchTimeInterval)
}

extension DispatchTimeInterval {
    func toDoubleValue() -> Double {
        return toDouble() ?? 0
    }

    func toDouble() -> Double? {
        var result: Double? = 0

        switch self {
        case .seconds(let value):
            result = Double(value)
        case .milliseconds(let value):
            result = Double(value) * 0.001
        case .microseconds(let value):
            result = Double(value) * 0.000001
        case .nanoseconds(let value):
            result = Double(value) * 0.000000001
        case .never:
            result = nil
        @unknown default:
            result = nil
        }

        return result
    }
}

public typealias RetryPredicate = (Error) -> Bool

extension RepeatBehavior {
    /**
     Extracts maxCount and calculates delay for current RepeatBehavior
     - parameter currentAttempt: Number of current attempt
     - returns: Tuple with maxCount and calculated delay for provided attempt
     */
    func calculateConditions(_ currentRepetition: UInt) -> (maxCount: UInt, delay: DispatchTimeInterval) {
        switch self {
        case .immediate(let max):
            // if Immediate, return 0.0 as delay
            return (maxCount: max, delay: .never)
        case .delayed(let max, let time):
            // return specified delay
            return (maxCount: max, delay: .milliseconds(Int(time * 1000)))
        case .exponentialDelayed(let max, let initial, let multiplier):
            if multiplier <= 1.0 {
                assertionFailure("multiplier smaller than 1.0 will cause delay time to decrease, consider makign multiplier greater than 1.0")
            }
            // if it's first attempt, simply use initial delay, otherwise calculate delay
            guard currentRepetition != 0 else { fatalError("RepeatBehavior currentRepetition should never start with 0") }
            let delay = currentRepetition == 1 ? initial : initial * pow(multiplier, Double(currentRepetition - 1))
            return (maxCount: max, delay: .milliseconds(Int(delay * 1000)))
        case .customTimerDelayed(let max, let delayCalculator):
            // calculate delay using provided calculator
            return (maxCount: max, delay: delayCalculator(currentRepetition))
        }
    }
}
