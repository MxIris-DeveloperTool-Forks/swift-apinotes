/// API notes for a variable/property.
public class Variable: Entity {
  /// The C type of the variable, as a string.
  public let type: String
  /// The kind of nullability for this property.
  /// `nil` if this variable has not been audited for nullability.
  public let nullability: Nullability?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    type: String,
    nullability: Nullability? = nil
  ) {
    self.type = type
    self.nullability = nullability
    super.init(
      name: name,
      swiftName: swiftName,
      isSwiftPrivate: isSwiftPrivate,
      availability: availability
    )
  }

  // MARK: - Conformance to Hashable

  public static func == (lhs: Variable, rhs: Variable) -> Bool {
    lhs as Entity == rhs as Entity &&
    lhs.type == rhs.type &&
    lhs.nullability == rhs.nullability
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(type)
    hasher.combine(nullability)
  }

  // MARK: - Conformance to Codable

  private enum CodingKeys: String, CodingKey {
    case nullability = "Nullability"
    case type = "Type"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decode(String.self, forKey: .type)
    nullability = try container.decodeIfPresent(
      Nullability.self, forKey: .nullability
    )
    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(nullability, forKey: .nullability)
    try container.encode(type, forKey: .type)
    try super.encode(to: encoder)
  }
}
