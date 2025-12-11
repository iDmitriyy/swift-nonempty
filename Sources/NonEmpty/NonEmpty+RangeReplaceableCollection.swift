// NB: `NonEmpty` does not conditionally conform to `RangeReplaceableCollection` because it contains destructive methods.
extension NonEmpty where Base: RangeReplaceableCollection {
  @inlinable @inline(__always)
  public init(_ a: Element) {
    var result = Base()
    result.reserveCapacity(1) // ? is it ok to reserve for 1 element
    result.append(a)
    self.init(_unsafeAssumedNonEmpty: result)
  }
  
  @inlinable @inline(__always)
  public init(_ a: Element, _ b: Element) {
    var result = Base()
    result.reserveCapacity(2)
        
    result.append(a)
    result.append(b)
    
    self.init(_unsafeAssumedNonEmpty: result)
  }
  
  @inlinable @inline(__always)
  public init(_ a: Element, _ b: Element, _ c: Element) {
    var result = Base()
    result.reserveCapacity(3)
        
    result.append(a)
    result.append(b)
    result.append(c)
    
    self.init(_unsafeAssumedNonEmpty: result)
  }
  
  @inlinable @inline(__always)
  public init(_ a: Element, _ b: Element, _ c: Element, _ d: Element, _ tail: Element...) {
    var result = Base()
    result.reserveCapacity(4 + tail.count)
        
    result.append(a)
    result.append(b)
    result.append(c)
    result.append(d)
    result.append(contentsOf: tail)
    
    self.init(_unsafeAssumedNonEmpty: result)
  }

  @inlinable @inline(__always)
  public init?<S>(_ elements: S) where S: Sequence, Base.Element == S.Element {
    self.init(rawValue: Base(elements))
  }

  @inlinable public mutating func append(_ newElement: Element) {
    _base.append(newElement)
  }

  @inlinable public mutating func append<S: Sequence>(contentsOf newElements: S) where Element == S.Element {
    _base.append(contentsOf: newElements)
  }

  @inlinable public mutating func insert(_ newElement: Element, at i: Index) {
    _base.insert(newElement, at: i)
  }

  @inlinable public mutating func insert<S>(
    contentsOf newElements: S, at i: Index,
  ) where S: Swift.Collection, Element == S.Element {
    _base.insert(contentsOf: newElements, at: i)
  }

  @inlinable public static func += <S: Sequence>(lhs: inout Self, rhs: S) where Element == S.Element {
    lhs.append(contentsOf: rhs)
  }

  @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  @inlinable public static func + <S: Sequence>(lhs: Self, rhs: S) -> Self where Element == S.Element {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  // TODO: - might be inefficient | ContiguousArray(lhs)
  public static func + <S: Sequence>(lhs: S, rhs: Self) -> Self where Element == S.Element {
    var rhs = rhs
    rhs.insert(contentsOf: ContiguousArray(lhs), at: rhs.startIndex)
    
    
    return rhs
  }
}

extension NonEmpty {
  @inlinable public func joined<C: RangeReplaceableCollection>(
    separator: some Sequence<C.Element>,
  )
    -> NonEmpty<C>
    where Element == NonEmpty<C> {
    NonEmpty<C>(rawValue: C(_base.joined(separator: separator)))!
  }

  @inlinable public func joined<C: RangeReplaceableCollection>() -> NonEmpty<C>
    where Element == NonEmpty<C> {
    joined(separator: C())
  }
}
