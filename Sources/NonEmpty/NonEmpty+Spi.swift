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
  
  @_spi(NonEmptyExternallyExtendable)
  @inlinable @inline(__always)
  public var _rawValueMutable: Collection {
    get { rawValue }
    _modify {
      yield &rawValue
    }
  }
    
  @_spi(NonEmptyExternallyExtendable)
  @inlinable @inline(__always)
  public init(_nonEmptyRawValueBuilder: () -> Collection) {
    let assumedNonEmptyRawValue = _nonEmptyRawValueBuilder()
//    precondition(!assumedNonEmptyRawValue.isEmpty,
//                 "Can't construct \(Self.self) from _nonEmptyRawValueBuilder that returns empty collection")
    self.init(rawValue: assumedNonEmptyRawValue)!
  }
}

extension NonEmpty where Collection: RangeReplaceableCollection {
  @inlinable @inline(__always)
  public init(head: Element, tail: [Element]) {
    var coll = Collection()
    coll.append(head)
    coll.append(contentsOf: tail)
    self.init(rawValue: coll)!
  }
  
  @inlinable @inline(__always)
  public init(head: Element, tail: Element...) {
    self.init(head: head, tail: tail)
  }
}
