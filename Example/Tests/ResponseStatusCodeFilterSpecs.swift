//
//  ResponseStatusCodeFilterSpecs.swift
//  OAuthAPIKit_Tests
//
//  Created by David on 2019/11/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Moya
import PromiseKit
import RxSwift

@testable import APIKit

fileprivate let error503 = Response(statusCode: 503, data: Data())
fileprivate let error401 = Response(statusCode: 401, data: Data())
fileprivate let redirect302 = Response(statusCode: 302, data: Data())
fileprivate let success200 = Response(statusCode: 200, data: Data())

class ResponseStatusCodeFilterSpecs: QuickSpec {

    var disposeBag: DisposeBag!

    override func spec() {

        beforeEach {
            self.disposeBag = DisposeBag()
        }

        context("When status code range is from 200 to 399, success code and redirect range.") {
            it("should throw error if status code is 503") {
                do {
                    try _ = error503.filterSuccessAndRedirectOrThrowNetworkClientError()
                    fail("filter range should always throw when getting 503 error code")
                } catch {
                    expect(error).to(beAKindOf(API.NetworkClientError.self))
                    _ = succeed()
                }
            }

            it("should throw error if status code is 401") {
                do {
                    try _ = error401.filterSuccessAndRedirectOrThrowNetworkClientError()
                    fail("filter range should always throw when getting 401 error code")
                } catch {
                    expect(error).to(beAKindOf(API.NetworkClientError.self))
                    _ = succeed()
                }
            }

            it("should success if status code is 200") {
                do {
                    try _ = success200.filterSuccessAndRedirectOrThrowNetworkClientError()
                    _ = succeed()
                } catch {
                    fail("should always success")
                }
            }

            it("should success if status code is 302") {
                do {
                    try _ = redirect302.filterSuccessAndRedirectOrThrowNetworkClientError()
                    _ = succeed()
                } catch {
                    fail("should always success")
                }
            }
        }

        context("When status code range is from 200 to 299, success code range.") {
            it("should throw error if status code is 401") {
                do {
                    try _ = error401.filterSuccessOrThrowNetworkClientError()
                    fail("filter range should always throw when getting 401 error code")
                } catch {
                    expect(error).to(beAKindOf(API.NetworkClientError.self))
                    _ = succeed()
                }
            }

            it("should success if status code is 200") {
                do {
                    try _ = success200.filterSuccessOrThrowNetworkClientError()
                    _ = succeed()
                } catch {
                    fail("should always success")
                }
            }

            it("should success if status code is 302") {
                do {
                    try _ = redirect302.filterSuccessOrThrowNetworkClientError()
                    fail("filter range should always throw when getting 302 redirect code")
                } catch {
                    expect(error).to(beAKindOf(API.NetworkClientError.self))
                    _ = succeed()
                }
            }
        }

        describe("Promise + Response status code filter") {
            context("Custom code range") {
                it("should pass given range of status code") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(error401)
                            .filteOrThrowNetworkClientErrorr(statusCodes: 200...299)
                            .done({ r in
                                fail("filter range should always throw when getting 401 error code")
                                done()
                            })
                            .catch({ e in
                                expect(e).to(beAKindOf(API.NetworkClientError.self))
                                done()
                            })
                    })

                    waitUntil(timeout: 2, action: { done in
                        Promise.value(success200)
                            .filteOrThrowNetworkClientErrorr(statusCodes: 200...299)
                            .done({ r in
                                done()
                            })
                            .catch({ e in
                                fail("should never fail")
                                done()
                            })
                    })
                }
            }

            context("Success code range") {
                it("should throw error if status code is 401") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(error401)
                            .filterSuccessThrowNetworkClientError()
                            .done({ r in
                                fail("filter range should always throw when getting 401 error code")
                                done()
                            })
                            .catch({ e in
                                expect(e).to(beAKindOf(API.NetworkClientError.self))
                                done()
                            })
                    })
                }

                it("should success if status code is 200") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(success200)
                            .filterSuccessThrowNetworkClientError()
                            .done({ r in
                                done()
                            })
                            .catch({ e in
                                fail("200 code should never fail")
                                done()
                            })
                    })
                }

                it("should success if status code is 302") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(redirect302)
                            .filterSuccessThrowNetworkClientError()
                            .done({ r in
                                fail("filter range should always throw when getting 302 redirect code")
                                done()
                            })
                            .catch({ e in
                                expect(e).to(beAKindOf(API.NetworkClientError.self))
                                done()
                            })
                    })
                }
            }

            context("Success code and redirect range") {
                it("should throw error if status code is 401") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(error401)
                            .filterSuccessAndRedirectOrThrowNetworkClientError()
                            .done({ r in
                                fail("filter range should always throw when getting 401 error code")
                                done()
                            })
                            .catch({ e in
                                expect(e).to(beAKindOf(API.NetworkClientError.self))
                                done()
                            })
                    })
                }

                it("should success if status code is 200") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(success200)
                            .filterSuccessAndRedirectOrThrowNetworkClientError()
                            .done({ r in
                                done()
                            })
                            .catch({ e in
                                fail("200 code should never fail")
                                done()
                            })
                    })
                }

                it("should success if status code is 302") {
                    waitUntil(timeout: 2, action: { done in
                        Promise.value(redirect302)
                            .filterSuccessAndRedirectOrThrowNetworkClientError()
                            .done({ r in
                                done()
                            })
                            .catch({ e in
                                fail("302 code should never fail in this case")
                                done()
                            })
                    })
                }
            }
        }

        describe("Single + Response status code filter") {
            context("Custom code range") {
                it("should pass given range of status code") {
                    waitUntil(timeout: 2, action: { done in
                        Single.just(error401)
                            .filterOrThrowNetworkClientError(statusCodes: 200...299)
                            .subscribe(
                                onSuccess: { r in
                                    fail("filter range should always throw when getting 401 error code")
                                    done()
                                },
                                onError: { e in
                                    expect(e).to(beAKindOf(API.NetworkClientError.self))
                                    done()
                                })
                            .disposed(by: self.disposeBag)
                    })

                    waitUntil(timeout: 2, action: { done in
                        Single.just(success200)
                            .filterOrThrowNetworkClientError(statusCodes: 200...299)
                            .subscribe(
                                onSuccess: { r in
                                    done()
                                },
                                onError: { e in
                                    fail("should never fail")
                                    done()
                                })
                            .disposed(by: self.disposeBag)
                    })
                }
            }

            context("Success code range") {
                it("should fail is status code is 302") {
                    waitUntil(timeout: 2, action: { done in
                        Single.just(redirect302)
                        .filterSuccessThrowNetworkClientError()
                            .subscribe(
                                onSuccess: { r in
                                    fail("302 should not be in success code randge.")
                                },
                                onError: { e in
                                    expect(e).to(beAKindOf(API.NetworkClientError.self))
                                    done()
                                })
                            .disposed(by: self.disposeBag)
                    })
                }
            }

            context("Success code and redirect range") {
                it("should success is status code is 302") {
                    waitUntil(timeout: 2, action: { done in
                        Single.just(redirect302)
                        .filterSuccessAndRedirectOrThrowNetworkClientError()
                            .subscribe(
                                onSuccess: { r in
                                    done()
                                },
                                onError: { e in
                                    fail("302 should always success in redirect range")
                                    done()
                                })
                            .disposed(by: self.disposeBag)
                    })
                }
            }
        }
    }

}
