extension NonEmpty: ExpressibleByDictionaryLiteral
where Base: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Base.Key, Base.Value)...) {
    precondition(!elements.isEmpty, "Can't construct \(Self.self) from empty dictionary literal")
    let f = unsafeBitCast(
      Base.init(dictionaryLiteral:),
      to: (([(Base.Key, Base.Value)]) -> Base).self
    )
    self.init(rawValue: f(elements))!
  }
}
