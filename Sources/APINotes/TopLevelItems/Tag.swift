/// Describes API notes data for a tag.
public final class Tag: TypeInfo {
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

  /// The kind of enumeration of this tag is an enumeration
  public let enumerationKind: EnumerationKind?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    swiftBridge: String? = nil,
    errorDomain: String? = nil,
    enumerationKind: EnumerationKind? = nil
  ) {
    self.enumerationKind = enumerationKind
    super.init(
      name: name,
      swiftName: swiftName,
      isSwiftPrivate: isSwiftPrivate,
      availability: availability,
      swiftBridge: swiftBridge,
      errorDomain: errorDomain
    )
  }

  // MARK: - Conformance to Hashable

  public static func == (lhs: Tag, rhs: Tag) -> Bool {
    lhs as TypeInfo == rhs as TypeInfo &&
    lhs.enumerationKind == rhs.enumerationKind
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(enumerationKind)
  }

  // MARK: - Conformance to Codable

  public required init(from decoder: Decoder) throws {
    // Try decoding the "complete" definition of enum + flag first, and only
    // if it fails decoding, fallback to the convenience kind decoding.
    if let enumerationKind = try Self.enumerationKind(from: decoder) {
      self.enumerationKind = enumerationKind
    } else if let enumerationKind = try Self.convenienceKind(from: decoder) {
      self.enumerationKind = enumerationKind
    } else {
      self.enumerationKind = nil
    }
    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
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
    try super.encode(to: encoder)
  }
}

// MARK: - Convenience Enum Kind

/// Syntactic sugar for Extensibility and Flag Enumeration
extension Tag.EnumerationKind {
  /// EnumExtensibility: open, FlagEnum: false
  public static var coreFoundationEnum: Self {
    .open(isFlagEnum: false)
  }
  /// EnumExtensibility: closed, FlagEnum: false
  public static var coreFoundationClosedEnum: Self {
    .closed(isFlagEnum: false)
  }
  /// EnumExtensibility: open, FlagEnum: true
  public static var coreFoundationOptions: Self {
    .open(isFlagEnum: true)
  }
}

// MARK: - Codable Support
extension Tag {
  private enum CodingKeys: String, CodingKey {
    case enumExtensibility = "EnumExtensibility"
    case flagEnum = "FlagEnum"
    case enumKind = "EnumKind"
  }

  fileprivate static func enumerationKind(
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

  fileprivate static func convenienceKind(
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
