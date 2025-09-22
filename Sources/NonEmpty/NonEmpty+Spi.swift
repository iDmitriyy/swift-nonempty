//
//  NonEmpty+Spi.swift
//  swift-nonempty
//
//  Created by Dmitriy Ignatyev on 22/09/2025.
//

extension NonEmpty {
  @_spi(NonEmptyExternallyExtendable)
  public mutating func _mutateRawValue(_ transform: (inout Collection) -> Void) {
    transform(&rawValue)
  }
  
  @_spi(NonEmptyExternallyExtendable)
  public var _rawValueMutable: Collection {
    get { rawValue }
    _modify {
      yield &rawValue
    }
  }
}
