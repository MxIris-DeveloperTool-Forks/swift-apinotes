/// Describes API notes data for a tag.
public struct Tag: TypeInfo, Hashable {
  /// Defines the C enumeration kind (is it a bitmask, or closed enum)
  ///
  /// The payload for an enum_extensibility attribute.
  public enum EnumerationKind: Hashable {
    /// Defines an open or extensible enumeration
    case open(isFlagEnum: Bool)
    /// Defines a closed or not extensible enumeration
    case closed(isFlagEnum: Bool)
    /// Indicates auditing
    case none // none
  }

  public var name: String

  public var swiftName: String?

  public var isSwiftPrivate: Bool?

  public var availability: Availability?

  public var swiftBridge: String?

  public var errorDomain: String?

  /// The kind of enumeration of this tag is an enumeration
  public var enumerationKind: EnumerationKind?

  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    swiftBridge: String? = nil,
    errorDomain: String? = nil,
    enumerationKind: EnumerationKind? = nil
  ) {
    self.name = name
    self.swiftName = swiftName
    self.isSwiftPrivate = isSwiftPrivate
    self.availability = availability
    self.swiftBridge = swiftBridge
    self.errorDomain = errorDomain
    self.enumerationKind = enumerationKind
  }
}

// MARK: - Conformance to Codable
extension Tag: Codable {
  private enum CodingKeys: String, CodingKey {
    case enumExtensibility = "EnumExtensibility"
    case flagEnum = "FlagEnum"
    case enumKind = "EnumKind"
  }

  public init(from decoder: Decoder) throws {
    // Try decoding the "complete" definition of enum + flag first, and only
    // if it fails then fallback to the convenience kind decoding.
    if let enumerationKind = try Self.enumerationKind(from: decoder) {
      self.enumerationKind = enumerationKind
    } else if let enumerationKind = try Self.convenienceKind(from: decoder) {
      self.enumerationKind = enumerationKind
    } else {
      self.enumerationKind = nil
    }
    (name, swiftName, isSwiftPrivate, availability) = try Self.decodeEntity(
      from: decoder
    )
    (swiftBridge, errorDomain) = try Self.decodeTypeInfo(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch enumerationKind {
    case let .open(isFlagEnum):
      try container.encode("open", forKey: .enumExtensibility)
      try container.encode(isFlagEnum, forKey: .flagEnum)
    case let .closed(isFlagEnum):
      try container.encode("closed", forKey: .enumExtensibility)
      try container.encode(isFlagEnum, forKey: .flagEnum)
    case .some(.none):
      try container.encode("none", forKey: .enumExtensibility)
    default: break
    }
    try encodeTypeInfo(to: encoder)
    try encodeEntity(to: encoder)
  }
}

// MARK: - Convenience Enum Kind

/// Syntactic sugar for Extensibility and Flag Enumeration
extension Tag.EnumerationKind {
  /// EnumExtensibility: open, FlagEnum: false
  static public var coreFoundationEnum: Self {
    .open(isFlagEnum: false)
  }
  /// EnumExtensibility: closed, FlagEnum: false
  static public var coreFoundationClosedEnum: Self {
    .closed(isFlagEnum: false)
  }
  /// EnumExtensibility: open, FlagEnum: true
  static public var coreFoundationOptions: Self {
    .open(isFlagEnum: true)
  }
}

// MARK: - Codable Support
extension Tag {
  static fileprivate func enumerationKind(
    from decoder: Decoder
  ) throws -> Tag.EnumerationKind? {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    guard let extensibility = try container.decodeIfPresent(
      String.self, forKey: .enumExtensibility
    ) else { return nil }

    switch extensibility {
    case "open":
      let isFlagEnum = try container.decode(Bool.self, forKey: .flagEnum)
      return .open(isFlagEnum: isFlagEnum)
    case "closed":
      let isFlagEnum = try container.decode(Bool.self, forKey: .flagEnum)
      return .closed(isFlagEnum: isFlagEnum)
    case "none":
      return Tag.EnumerationKind.none
    default:
      throw DecodingError.typeMismatch(
        Tag.EnumerationKind.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "\(extensibility) is not a valid enumeration " +
            "extensibility. Use either none, open or closed"
        ))
    }
  }

  static fileprivate func convenienceKind(
    from decoder: Decoder
  ) throws -> Tag.EnumerationKind? {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    guard let enumKind = try container.decodeIfPresent(
      String.self, forKey: .enumKind
    ) else { return nil }

    switch enumKind {
    case "NSEnum", "CFEnum":
      return .coreFoundationEnum
    case "NSClosedEnum", "CFClosedEnum":
      return .coreFoundationClosedEnum
    case "NSOptions", "CFOptions":
      return .coreFoundationOptions
    case "none":
      return Tag.EnumerationKind.none
    default:
      throw DecodingError.typeMismatch(
        Tag.EnumerationKind.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "\(enumKind) is not a valid convenience " +
            "enumeration kind. Use either NSEnum (or CFEnum), " +
            "NSClosedEnum (or CFClosedEnum) or NSOptions (or CFOptions)"
        ))
    }
  }
}
