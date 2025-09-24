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
  public var _rawValueReadModify: Collection {
    read { yield rawValue }
    modify { yield &rawValue }
  }
}
