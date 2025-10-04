@dynamicMemberLookup
public struct NonEmpty<Base: Swift.Collection>: Swift.Collection {
  public typealias Element = Base.Element
  public typealias Index = Base.Index
  
  @usableFromInline var _base: Base
  
  @available(*, deprecated, message: "Will be obsoleted. Use `base` property instead")
  public var rawValue: Base { _base }

  @available(*, deprecated, message: "Use `init?(base: Base)` instead")
  public init?(rawValue: Base) {
    guard !rawValue.isEmpty else { return nil }
    self._base = rawValue
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<Base, Subject>) -> Subject {
    self._base[keyPath: keyPath]
  }

  public var startIndex: Index { self._base.startIndex }

  public var endIndex: Index { self._base.endIndex }

  public subscript(position: Index) -> Element { self._base[position] }

  public func index(after i: Index) -> Index {
    self._base.index(after: i)
  }

  public var first: Element { self._base.first! } // or _base[0] is faster?

  public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self._base.max(by: areInIncreasingOrder)!
  }

  public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self._base.min(by: areInIncreasingOrder)!
  }

  public func sorted(
    by areInIncreasingOrder: (Element, Element) throws -> Bool,
  ) rethrows -> NonEmpty<[Element]> {
    try NonEmpty<[Element]>(rawValue: self._base.sorted(by: areInIncreasingOrder))!
  }

  public func randomElement(using generator: inout some RandomNumberGenerator) -> Element {
    self._base.randomElement(using: &generator)!
  }

  public func randomElement() -> Element {
    self._base.randomElement()!
  }

  public func shuffled(using generator: inout some RandomNumberGenerator) -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: self._base.shuffled(using: &generator))!
  }

  public func shuffled() -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: self._base.shuffled())!
  }

  public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmpty<[T]> {
    try NonEmpty<[T]>(rawValue: self._base.map(transform))!
  }

  public func flatMap<SegmentOfResult>(
    _ transform: (Element) throws -> NonEmpty<SegmentOfResult>,
  ) rethrows -> NonEmpty<[SegmentOfResult.Element]> where SegmentOfResult: Sequence {
    try NonEmpty<[SegmentOfResult.Element]>(rawValue: self._base.flatMap(transform))!
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    String(describing: self._base)
  }
}

extension NonEmpty: Equatable where Base: Equatable {}

extension NonEmpty: Hashable where Base: Hashable {}

extension NonEmpty: Comparable where Base: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs._base < rhs._base
  }
}

#if canImport(_Concurrency) && compiler(>=5.5)
  extension NonEmpty: Sendable where Base: Sendable {}
#endif

extension NonEmpty: Encodable where Base: Encodable {
  public func encode(to encoder: any Encoder) throws {
    do {
      var container = encoder.singleValueContainer()
      try container.encode(self._base)
    } catch {
      try self._base.encode(to: encoder)
    }
  }
}

extension NonEmpty: Decodable where Base: Decodable {
  public init(from decoder: any Decoder) throws {
    let collection: Base
    do {
      collection = try decoder.singleValueContainer().decode(Base.self)
    } catch {
      collection = try Base(from: decoder)
    }

    guard !collection.isEmpty else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: "Non-empty collection expected"),
      )
    }
    self.init(rawValue: collection)!
  }
}

// extension NonEmpty: RawRepresentable {}

extension NonEmpty where Base.Element: Comparable {
  public func max() -> Element {
    self._base.max()!
  }

  public func min() -> Element {
    self._base.min()!
  }

  public func sorted() -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: self._base.sorted())!
  }
}

extension NonEmpty: BidirectionalCollection where Base: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self._base.index(before: i)
  }

  public var last: Element { self._base.last! }
}

extension NonEmpty: MutableCollection where Base: MutableCollection {
  public subscript(position: Index) -> Element {
    _read { yield self._base[position] }
    _modify { yield &self._base[position] }
  }
}

extension NonEmpty: RandomAccessCollection where Base: RandomAccessCollection {}

extension NonEmpty where Base: MutableCollection & RandomAccessCollection {
  public mutating func shuffle(using generator: inout some RandomNumberGenerator) {
    self._base.shuffle(using: &generator)
  }
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>

// MARK: - SPI

extension NonEmpty {
  /// _modify accessor for mutation
  @_spi(NonEmptyExternallyExtendable)
  @inlinable @inline(__always)
  public var _baseReadModify: Base {
    read { yield _base }
    modify { yield &_base } // is it actual?: https://github.com/apple/swift-collections/issues/164
  }
  
  @inlinable @inline(__always)
  public init(_unsafeAssumedNonEmpty _assumedNonEmptyBase: Base) {
    guard !_assumedNonEmptyBase.isEmpty else {
      fatalError("NonEmpty can not be initialized with collection \(Base.self) of count 0")
    }
    self._base = _assumedNonEmptyBase
  }
}

extension NonEmpty {
  @inlinable public var base: Base { _base }
  
  @inlinable @inline(__always)
  public init?(base: Base) {
    guard !base.isEmpty else { return nil }
    self._base = base
  }
}
