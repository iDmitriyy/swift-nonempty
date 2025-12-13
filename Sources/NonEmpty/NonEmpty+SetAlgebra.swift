public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable

// NB: `NonEmpty` does not conditionally conform to `SetAlgebra` because it contains destructive methods.
extension NonEmpty where Base: SetAlgebra, Base.Element: Hashable {
  @inlinable @inline(__always) public init(_ head: Base.Element, _ tail: Base.Element...) {
    var tail = Base(tail)
    tail.insert(head)
    self.init(rawValue: tail)!
  }

  @inlinable @inline(__always) public init?<S>(_ elements: S) where S: Sequence, Base.Element == S.Element {
    self.init(rawValue: Base(elements))
  }

  @inlinable @inline(__always) public func contains(_ member: Base.Element) -> Bool {
    self._base.contains(member)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func union(_ other: NonEmpty) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  @inlinable @inline(__always) public func union(_ other: Base) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func intersection(_ other: NonEmpty) -> Base {
    self._base.intersection(other._base)
  }

  @inlinable @inline(__always) public func intersection(_ other: Base) -> Base {
    self._base.intersection(other)
  }

  @_disfavoredOverload
  public func symmetricDifference(_ other: NonEmpty) -> Base {
    self._base.symmetricDifference(other._base)
  }

  @inlinable @inline(__always) public func symmetricDifference(_ other: Base) -> Base {
    self._base.symmetricDifference(other)
  }

  @discardableResult
  @inlinable @inline(__always) public mutating func insert(_ newMember: Base.Element) -> (
    inserted: Bool, memberAfterInsert: Base.Element
  ) {
    self._base.insert(newMember)
  }

  @discardableResult
  @inlinable @inline(__always) public mutating func update(with newMember: Base.Element) -> Base.Element? {
    self._base.update(with: newMember)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public mutating func formUnion(_ other: NonEmpty) {
    self._base.formUnion(other._base)
  }

  @inlinable @inline(__always) public mutating func formUnion(_ other: Base) {
    self._base.formUnion(other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func subtracting(_ other: NonEmpty) -> Base {
    self._base.subtracting(other._base)
  }

  @inlinable @inline(__always) public func subtracting(_ other: Base) -> Base {
    self._base.subtracting(other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func isDisjoint(with other: NonEmpty) -> Bool {
    self._base.isDisjoint(with: other._base)
  }

  @inlinable @inline(__always) public func isDisjoint(with other: Base) -> Bool {
    self._base.isDisjoint(with: other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func isSubset(of other: NonEmpty) -> Bool {
    self._base.isSubset(of: other._base)
  }

  @inlinable @inline(__always) public func isSubset(of other: Base) -> Bool {
    self._base.isSubset(of: other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func isSuperset(of other: NonEmpty) -> Bool {
    self._base.isSuperset(of: other._base)
  }

  @inlinable @inline(__always) public func isSuperset(of other: Base) -> Bool {
    self._base.isSuperset(of: other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always) public func isStrictSubset(of other: NonEmpty) -> Bool {
    self._base.isStrictSubset(of: other._base)
  }

  @inlinable @inline(__always) public func isStrictSubset(of other: Base) -> Bool {
    self._base.isStrictSubset(of: other)
  }

  @_disfavoredOverload
  @inlinable @inline(__always)  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    self._base.isStrictSuperset(of: other._base)
  }

  @inlinable @inline(__always) public func isStrictSuperset(of other: Base) -> Bool {
    self._base.isStrictSuperset(of: other)
  }
}

extension SetAlgebra where Self: Collection, Element: Hashable {
  @inlinable @inline(__always) public func union(_ other: NonEmpty<Self>) -> NonEmpty<Self> {
    var copy = other
    copy.formUnion(self)
    return copy
  }

  @inlinable @inline(__always) public func intersection(_ other: NonEmpty<Self>) -> Self {
    self.intersection(other._base)
  }

  @inlinable @inline(__always) public func symmetricDifference(_ other: NonEmpty<Self>) -> Self {
    self.symmetricDifference(other._base)
  }

  @inlinable @inline(__always) public mutating func formUnion(_ other: NonEmpty<Self>) {
    self.formUnion(other._base)
  }

  @inlinable @inline(__always) public func subtracting(_ other: NonEmpty<Self>) -> Self {
    self.subtracting(other._base)
  }

  @inlinable @inline(__always) public func isDisjoint(with other: NonEmpty<Self>) -> Bool {
    self.isDisjoint(with: other._base)
  }

  @inlinable @inline(__always) public func isSubset(of other: NonEmpty<Self>) -> Bool {
    self.isSubset(of: other._base)
  }

  @inlinable @inline(__always) public func isSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isSuperset(of: other._base)
  }

  @inlinable @inline(__always) public func isStrictSubset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSubset(of: other._base)
  }

  @inlinable @inline(__always) public func isStrictSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSuperset(of: other._base)
  }
}
