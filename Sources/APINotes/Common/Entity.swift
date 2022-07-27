/// Describes API notes data for any entity, i.e. a type that can be renamed
/// from its definition in the C language into a more appropriate name in the
/// Swift language or even hidden from the interface.
///
/// This is used as the base of all API notes.
public class Entity: Hashable, Codable {
  /// The original name of the definition (in C language)
  public let name: String

  /// The more appropriate name in Swift language.
  /// Equivalent to NS_SWIFT_NAME.
  public let swiftName: String?

  /// Whether this entity is considered "private" to a Swift overlay.
  /// Equivalent to NS_REFINED_FOR_SWIFT.
  public let isSwiftPrivate: Bool?

  /// Specifies which platform the API is available on.
  public let availability: Availability?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil
  ) {
    self.name = name
    self.swiftName = swiftName
    self.isSwiftPrivate = isSwiftPrivate
    self.availability = availability
  }

  // MARK: - Conformance to Hashable

  public static func == (lhs: Entity, rhs: Entity) -> Bool {
    lhs.name == rhs.name &&
    lhs.swiftName == rhs.swiftName &&
    lhs.isSwiftPrivate == rhs.isSwiftPrivate &&
    lhs.availability == rhs.availability
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(swiftName)
    hasher.combine(isSwiftPrivate)
    hasher.combine(availability)
  }

  // MARK: - Conformance to Codable

  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case swiftName = "SwiftName"
    case isSwiftPrivate = "SwiftPrivate"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    swiftName = try container.decodeIfPresent(String.self, forKey: .swiftName)
    isSwiftPrivate = try container.decodeIfPresent(
      Bool.self, forKey: .isSwiftPrivate
    )
    availability = try Availability.decodeAvailabilityIfPresent(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(swiftName, forKey: .swiftName)
    try container.encodeIfPresent(isSwiftPrivate, forKey: .isSwiftPrivate)
    try availability?.encode(to: encoder)
  }
}
