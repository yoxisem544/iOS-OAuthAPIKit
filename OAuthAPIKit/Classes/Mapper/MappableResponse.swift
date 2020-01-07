//
//  MappableResponse.swift
//  OAuthAPIKit
//
//  Created by David on 2019/11/20.
//

import Mapper

/// Response that can be decoded by `Mapper`
public protocol MappableResponse {
    associatedtype ResponseType: Mappable
}
