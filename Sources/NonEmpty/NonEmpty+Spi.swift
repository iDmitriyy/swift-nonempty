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

extension NonEmpty {
  // @inlinable @inline(always) // https://github.com/swiftlang/swift/issues/50132
  public init?(base: Base) {
    guard !base.isEmpty else { return nil }
    self.rawValue = base
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
