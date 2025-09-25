//
//  NonEmpty+Spi.swift
//  swift-nonempty
//
//  Created by Dmitriy Ignatyev on 22/09/2025.
//

extension NonEmpty {
  /// _modify accessor for mutation
  @_spi(NonEmptyExternallyExtendable)
  @inlinable @inline(__always)
  public var _baseReadModify: Base {
    read { yield rawValue }
    modify { yield &rawValue }
  }
}

public protocol NonEmptyCompatibleCollection: Collection {}

//extension Array: NonEmptyCompatibleCollection {}
//
//extension Set: NonEmptyCompatibleCollection {}
//
//extension Dictionary: NonEmptyCompatibleCollection {}
//
//extension String: NonEmptyCompatibleCollection {}
