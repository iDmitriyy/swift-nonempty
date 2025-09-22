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
    
  @_spi(NonEmptyExternallyExtendable)
  public init(_nonEmptyRawValueBuilder: () -> Collection) {
    let assumedNonEmptyRawValue = _nonEmptyRawValueBuilder()
    precondition(!assumedNonEmptyRawValue.isEmpty,
                 "Can't construct \(Self.self) from _nonEmptyRawValueBuilder that returns empty collection")
    self.init(rawValue: assumedNonEmptyRawValue)!
  }
}
