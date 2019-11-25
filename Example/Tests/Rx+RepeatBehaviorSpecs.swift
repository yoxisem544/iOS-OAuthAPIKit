//
//  Rx+RepeatBehaviorSpecs.swift
//  APIKit_Tests
//
//  Created by David on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import RxTest
import RxBlocking
import RxNimble

@testable import APIKit

class Rx_RepeatBehaviorSpecs: QuickSpec {

    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    var error: Error?

    override func spec() {

        beforeEach {
            failHandShack = 0
            successHandShack = 0
            self.error = nil

            self.testScheduler = TestScheduler(initialClock: 0, resolution: 0.1)
            self.disposeBag = DisposeBag()
        }

        describe("Spec of Rx and Repear Behavior") {
            context("Single and Retry") {

                it("should get 1, 2, 3") {
                    let numberObserver = self.testScheduler.createObserver(Int.self)

                    self.testScheduler.createColdObservable([
                        .next(10, 1),
                        .next(20, 2),
                        .next(30, 3)
                        ])
                        .subscribe(onNext: { [numberObserver] n in numberObserver.onNext(n) })
                        .disposed(by: self.disposeBag)

                    self.testScheduler.start()

                    expect(numberObserver.events).to(equal([
                        Recorded.next(10, 1),
                        Recorded.next(20, 2),
                        Recorded.next(30, 3),
                    ]))
                }

                it("should retry for 5 time in 3 seconds") {
                    waitUntil(timeout: 3, action: { done in
                        singleError()
                            .retry(RepeatBehavior.delayed(maxCount: 5, time: 0.2))
                            .subscribe(onSuccess: {
                                fail("single will never success")
                            }, onError: { e in
                                expect(failHandShack).to(equal(5))
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }

                it("should at least execute once if retry count is 0") {
                    waitUntil(timeout: 3, action: { done in
                        singleError()
                            .retry(RepeatBehavior.delayed(maxCount: 0, time: 0.2))
                            .subscribe(onSuccess: {
                                fail("single will never success")
                            }, onError: { e in
                                expect(e).to(beAKindOf(NSError.self)) // should be same kind of error as defined below
                                expect(failHandShack).to(equal(1))
                                done()
                            })
                            .disposed(by: self.disposeBag)
                    })
                }

            }
        }

    }

}

fileprivate var failHandShack: Int = 0
fileprivate var successHandShack: Int = 0

fileprivate func singleError() -> Single<Void> {
    return Single<Void>.create(subscribe: { single in
        failHandShack += 1
        single(.error(NSError(domain: "", code: -1, userInfo: nil)))
        return Disposables.create {

        }
    })
}

fileprivate func singleOK() -> Single<Void> {
    return Single<Void>.create(subscribe: { single in
        successHandShack += 1
        single(.success(()))
        return Disposables.create {

        }
    })
}
