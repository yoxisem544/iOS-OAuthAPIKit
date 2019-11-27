//
//  DecodableResponse.swift
//  APIKit
//
//  Created by David on 2019/11/20.
//

import Foundation

/// Response that can be decoded by Swift's standard Decodable procotol
public protocol DecodableResponse {
    associatedtype ResponseType: Decodable
}
