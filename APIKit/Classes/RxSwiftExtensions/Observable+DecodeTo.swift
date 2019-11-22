//
//  Observable+DecodeTo.swift
//  APIKit
//
//  Created by David on 2019/11/22.
//

import ObjectMapper
import Moya
import RxSwift
import SwiftyJSON

extension ObservableType where E == Response {

    func decodeToJSON() -> Observable<JSON> {
        return flatMap({ response -> Observable<JSON> in
            do {
                return .just(try JSON(data: response.data))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    func decode<T: BaseMappable>(to type: T.Type) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            do {
                return .just(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

    func decode<T: Decodable>(to type: T.Type) -> Observable<T> {
        return flatMap({ response -> Observable<T> in
            do {
                return .just(try response.map(type))
            } catch {
                throw API.NetworkClientError.decodingError(error: error)
            }
        })
    }

}
