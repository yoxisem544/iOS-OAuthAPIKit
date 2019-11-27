//
//  MappableResponse.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/20.
//

import ObjectMapper

/// Response that can be decoded by `ObjectMapper`
public protocol MappableResponse {
    associatedtype ResponseType: Mappable
}

public protocol ImmutableMappableResponse {
    associatedtype ResponseType: ImmutableMappable
}
