/// API notes for a variable/property.
public struct Variable: Entity, Hashable {
  /// The original name of the definition (in C language)
  public var name: String
  /// The more appropriate name in Swift language.
  /// Equivalent to NS_SWIFT_NAME.
  public var swiftName: String?
  /// Whether this entity is considered "private" to a Swift overlay.
  /// Equivalent to NS_REFINED_FOR_SWIFT.
  public var isSwiftPrivate: Bool?
  /// Specifies which platform the API is available on.
  public var availability: Availability?
  /// The C type of the variable, as a string.
  public var type: String?
  /// The kind of nullability for this property.
  /// `nil` if this variable has not been audited for nullability.
  public var nullability: Nullability?

  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    type: String? = nil,
    nullability: Nullability? = nil
  ) {
    self.name = name
    self.swiftName = swiftName
    self.isSwiftPrivate = isSwiftPrivate
    self.availability = availability
    self.type = type
    self.nullability = nullability
  }
}

// MARK: - Conformance to Codable
extension Variable: Codable {
  private enum CodingKeys: String, CodingKey {
    case nullability = "Nullability"
    case type = "Type"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decodeIfPresent(String.self, forKey: .type)
    nullability = try container.decodeIfPresent(
      Nullability.self, forKey: .nullability
    )
    (name, swiftName, isSwiftPrivate, availability) = try Self.decodeEntity(
      from: decoder
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(nullability, forKey: .nullability)
    try container.encode(type, forKey: .type)
    try encodeEntity(to: encoder)
  }
}
