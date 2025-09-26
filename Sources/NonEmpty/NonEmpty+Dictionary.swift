public typealias NonEmptyDictionary<Key, Value> = NonEmpty<[Key: Value]> where Key: Hashable

public protocol _DictionaryProtocol: Collection where Element == (key: Key, value: Value) {
  associatedtype Key: Hashable
  associatedtype Value
  var keys: Dictionary<Key, Value>.Keys { get }
  subscript(key: Key) -> Value? { get set }
  mutating func merge<S: Sequence>(
    _ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows where S.Element == (Key, Value)
  mutating func merge(
    _ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows
  @discardableResult mutating func removeValue(forKey key: Key) -> Value?
  @discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value?
}

extension Dictionary: _DictionaryProtocol {}

extension NonEmpty where Base: _DictionaryProtocol {
  public init(_ head: Element, _ tail: Base) {
    guard !tail.keys.contains(head.key) else { fatalError("Dictionary contains duplicate key") }
    var tail = tail
    tail[head.key] = head.value
    self.init(rawValue: tail)!
  }

  public init(
    _ head: Element,
    _ tail: Base,
    uniquingKeysWith combine: (Base.Value, Base.Value) throws -> Base.Value
  ) rethrows {

    var tail = tail
    if let otherValue = tail.removeValue(forKey: head.0) {
      tail[head.key] = try combine(head.value, otherValue)
    } else {
      tail[head.key] = head.value
    }
    self.init(rawValue: tail)!
  }

  public subscript(key: Base.Key) -> Base.Value? {
    self._base[key]
  }

  public mutating func merge<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (Base.Value, Base.Value) throws -> Base.Value
  ) rethrows where S.Element == (Base.Key, Base.Value) {

    try self._base.merge(other, uniquingKeysWith: combine)
  }

  public func merging<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (Base.Value, Base.Value) throws -> Base.Value
  ) rethrows -> NonEmpty where S.Element == (Base.Key, Base.Value) {

    var copy = self
    try copy.merge(other, uniquingKeysWith: combine)
    return copy
  }

  public mutating func merge(
    _ other: [Base.Key: Base.Value],
    uniquingKeysWith combine: (Base.Value, Base.Value) throws -> Base.Value
  ) rethrows {

    try self._base.merge(other, uniquingKeysWith: combine)
  }

  public func merging(
    _ other: [Base.Key: Base.Value],
    uniquingKeysWith combine: (Base.Value, Base.Value) throws -> Base.Value
  ) rethrows -> NonEmpty {

    var copy = self
    try copy.merge(other, uniquingKeysWith: combine)
    return copy
  }

  @discardableResult
  public mutating func updateValue(_ value: Base.Value, forKey key: Base.Key)
    -> Base.Value?
  {
    self._base.updateValue(value, forKey: key)
  }
}

extension NonEmpty where Base: _DictionaryProtocol, Base.Value: Equatable {
  public static func == (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return Dictionary(uniqueKeysWithValues: Array(lhs))
      == Dictionary(uniqueKeysWithValues: Array(rhs))
  }
}

extension NonEmpty where Base: _DictionaryProtocol & ExpressibleByDictionaryLiteral {
  public init(_ head: Element) {
    self.init(rawValue: [head.key: head.value])!
  }
}
