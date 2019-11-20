//
//  DecodableResponse.swift
//  APIKit
//
//  Created by David on 2019/11/20.
//

import Foundation

public protocol DecodableResponse {
    associatedtype ResponseType: Decodable
    var jsonDecodingEntryPath: String? { get }
}

extension DecodableResponse {
    // default to no json entry point
    var jsonDecodingEntryPath: String? { return nil }
}
