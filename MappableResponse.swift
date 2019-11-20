//
//  MappableResponse.swift
//  APIKit
//
//  Created by David on 2019/11/20.
//

import ObjectMapper

public protocol MappableResponse {
    associatedtype ResponseType: BaseMappable
}
