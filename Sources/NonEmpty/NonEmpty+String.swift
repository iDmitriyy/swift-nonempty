public typealias NonEmptyString = NonEmpty<String>

extension NonEmptyString {
  @_disfavoredOverload
  public init?<T>(_ value: T) where T: LosslessStringConvertible {
    self.init(String(value))
  }
}

extension NonEmpty: ExpressibleByUnicodeScalarLiteral
where Base: ExpressibleByUnicodeScalarLiteral {
  public typealias UnicodeScalarLiteralType = Base.UnicodeScalarLiteralType

  public init(unicodeScalarLiteral value: Base.UnicodeScalarLiteralType) {
    self.init(rawValue: Base(unicodeScalarLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByExtendedGraphemeClusterLiteral
where Base: ExpressibleByExtendedGraphemeClusterLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = Base
    .ExtendedGraphemeClusterLiteralType

  public init(extendedGraphemeClusterLiteral value: Base.ExtendedGraphemeClusterLiteralType) {
    self.init(rawValue: Base(extendedGraphemeClusterLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByStringLiteral where Base: ExpressibleByStringLiteral {
  public typealias StringLiteralType = Base.StringLiteralType

  public init(stringLiteral value: Base.StringLiteralType) {
    self.init(rawValue: Base(stringLiteral: value))!
  }
}

extension NonEmpty: TextOutputStreamable where Base: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    self.rawValue.write(to: &target)
  }
}

extension NonEmpty: TextOutputStream where Base: TextOutputStream {
  public mutating func write(_ string: String) {
    self.rawValue.write(string)
  }
}

extension NonEmpty: LosslessStringConvertible where Base: LosslessStringConvertible {
  public init?(_ description: String) {
    guard let string = Base(description) else { return nil }
    self.init(rawValue: string)
  }
}

extension NonEmpty: ExpressibleByStringInterpolation
where
  Base: ExpressibleByStringInterpolation,
  Base.StringLiteralType == DefaultStringInterpolation.StringLiteralType
{}

extension NonEmpty where Base: StringProtocol {
  public typealias UTF8View = Base.UTF8View
  public typealias UTF16View = Base.UTF16View
  public typealias UnicodeScalarView = Base.UnicodeScalarView

  public var utf8: UTF8View { self.rawValue.utf8 }
  public var utf16: UTF16View { self.rawValue.utf16 }
  public var unicodeScalars: UnicodeScalarView { self.rawValue.unicodeScalars }

  public init<C, Encoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  ) where C: Swift.Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit {
    self.init(rawValue: Base(decoding: codeUnits, as: sourceEncoding))!
  }

  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(rawValue: Base(cString: nullTerminatedUTF8))!
  }

  public init<Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) where Encoding: _UnicodeEncoding {
    self.init(rawValue: Base(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))!
  }

  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows
    -> Result
  {
    try self.rawValue.withCString(body)
  }

  public func withCString<Result, Encoding>(
    encodedAs targetEncoding: Encoding.Type,
    _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result
  ) rethrows -> Result where Encoding: _UnicodeEncoding {
    try self.rawValue.withCString(encodedAs: targetEncoding, body)
  }

  public func lowercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.lowercased())!
  }

  public func uppercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.uppercased())!
  }
}
