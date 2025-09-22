//
//  NonEmpty+Spi.swift
//  swift-nonempty
//
//  Created by Dmitriy Ignatyev on 22/09/2025.
//

extension NonEmpty {
  // @inlinable @inline(__always)
  @_spi(NonEmptyExternallyExtendable)
  public mutating func _mutateRawValue(_ transform: (inout Collection) -> Void) {
    transform(&rawValue)
  }
  
  /// _modify accessor for mutation
  @_spi(NonEmptyExternallyExtendable)
  @inlinable @inline(__always)
  public var _rawValueMutable: Collection {
    get { rawValue }
    _modify {
      yield &rawValue
    }
  }
}
