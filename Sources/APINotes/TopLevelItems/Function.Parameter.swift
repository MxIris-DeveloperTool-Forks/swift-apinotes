extension Function {
  /// Describes a function parameter.
  public final class Parameter: Variable {
    /// Whether the this parameter has the 'noescape' attribute.
    public let isNoneEscaping: Bool?

    /// Creates a new instance from given values
    public init(
      name: String,
      swiftName: String? = nil,
      isSwiftPrivate: Bool? = nil,
      availability: Availability? = nil,
      type: String,
      nullability: Nullability? = nil,
      isNoneEscaping: Bool?
    ) {
      self.isNoneEscaping = isNoneEscaping
      super.init(
        name: name,
        swiftName: swiftName,
        isSwiftPrivate: isSwiftPrivate,
        availability: availability,
        type: type,
        nullability: nullability
      )
    }

    // MARK: - Conformance to Hashable

    public static func == (lhs: Parameter, rhs: Parameter) -> Bool {
      lhs as Variable == rhs as Variable &&
      lhs.isNoneEscaping == rhs.isNoneEscaping
    }

    public override func hash(into hasher: inout Hasher) {
      super.hash(into: &hasher)
      hasher.combine(isNoneEscaping)
    }

    // MARK: - Conformance to Codable

    private enum CodingKeys: String, CodingKey {
      case isNoneEscaping = "NoEscape"
    }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      isNoneEscaping = try container.decodeIfPresent(
        Bool.self, forKey: .isNoneEscaping
      )
      try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encodeIfPresent(isNoneEscaping, forKey: .isNoneEscaping)
      try super.encode(to: encoder)
    }
  }
}
