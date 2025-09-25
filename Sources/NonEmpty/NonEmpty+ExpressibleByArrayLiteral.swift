extension NonEmpty: ExpressibleByArrayLiteral where Base: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    precondition(!elements.isEmpty, "Can't construct \(Self.self) from empty array literal")
    let f = unsafeBitCast(
      Base.init(arrayLiteral:),
      to: (([Element]) -> Base).self
    )
    self.init(rawValue: f(elements))!
  }
}
