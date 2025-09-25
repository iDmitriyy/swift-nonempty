public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable

// NB: `NonEmpty` does not conditionally conform to `SetAlgebra` because it contains destructive methods.
extension NonEmpty where Base: SetAlgebra, Base.Element: Hashable {
  public init(_ head: Base.Element, _ tail: Base.Element...) {
    var tail = Base(tail)
    tail.insert(head)
    self.init(rawValue: tail)!
  }

  public init?<S>(_ elements: S) where S: Sequence, Base.Element == S.Element {
    self.init(rawValue: Base(elements))
  }

  public func contains(_ member: Base.Element) -> Bool {
    self.rawValue.contains(member)
  }

  @_disfavoredOverload
  public func union(_ other: NonEmpty) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func union(_ other: Base) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  @_disfavoredOverload
  public func intersection(_ other: NonEmpty) -> Base {
    self.rawValue.intersection(other.rawValue)
  }

  public func intersection(_ other: Base) -> Base {
    self.rawValue.intersection(other)
  }

  @_disfavoredOverload
  public func symmetricDifference(_ other: NonEmpty) -> Base {
    self.rawValue.symmetricDifference(other.rawValue)
  }

  public func symmetricDifference(_ other: Base) -> Base {
    self.rawValue.symmetricDifference(other)
  }

  @discardableResult
  public mutating func insert(_ newMember: Base.Element) -> (
    inserted: Bool, memberAfterInsert: Base.Element
  ) {
    self.rawValue.insert(newMember)
  }

  @discardableResult
  public mutating func update(with newMember: Base.Element) -> Base.Element? {
    self.rawValue.update(with: newMember)
  }

  @_disfavoredOverload
  public mutating func formUnion(_ other: NonEmpty) {
    self.rawValue.formUnion(other.rawValue)
  }

  public mutating func formUnion(_ other: Base) {
    self.rawValue.formUnion(other)
  }

  @_disfavoredOverload
  public func subtracting(_ other: NonEmpty) -> Base {
    self.rawValue.subtracting(other.rawValue)
  }

  public func subtracting(_ other: Base) -> Base {
    self.rawValue.subtracting(other)
  }

  @_disfavoredOverload
  public func isDisjoint(with other: NonEmpty) -> Bool {
    self.rawValue.isDisjoint(with: other.rawValue)
  }

  public func isDisjoint(with other: Base) -> Bool {
    self.rawValue.isDisjoint(with: other)
  }

  @_disfavoredOverload
  public func isSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isSubset(of: other.rawValue)
  }

  public func isSubset(of other: Base) -> Bool {
    self.rawValue.isSubset(of: other)
  }

  @_disfavoredOverload
  public func isSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isSuperset(of: other.rawValue)
  }

  public func isSuperset(of other: Base) -> Bool {
    self.rawValue.isSuperset(of: other)
  }

  @_disfavoredOverload
  public func isStrictSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSubset(of other: Base) -> Bool {
    self.rawValue.isStrictSubset(of: other)
  }

  @_disfavoredOverload
  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSuperset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: Base) -> Bool {
    self.rawValue.isStrictSuperset(of: other)
  }
}

extension SetAlgebra where Self: Collection, Element: Hashable {
  public func union(_ other: NonEmpty<Self>) -> NonEmpty<Self> {
    var copy = other
    copy.formUnion(self)
    return copy
  }

  public func intersection(_ other: NonEmpty<Self>) -> Self {
    self.intersection(other.rawValue)
  }

  public func symmetricDifference(_ other: NonEmpty<Self>) -> Self {
    self.symmetricDifference(other.rawValue)
  }

  public mutating func formUnion(_ other: NonEmpty<Self>) {
    self.formUnion(other.rawValue)
  }

  public func subtracting(_ other: NonEmpty<Self>) -> Self {
    self.subtracting(other.rawValue)
  }

  public func isDisjoint(with other: NonEmpty<Self>) -> Bool {
    self.isDisjoint(with: other.rawValue)
  }

  public func isSubset(of other: NonEmpty<Self>) -> Bool {
    self.isSubset(of: other.rawValue)
  }

  public func isSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isSuperset(of: other.rawValue)
  }

  public func isStrictSubset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSuperset(of: other.rawValue)
  }
}
