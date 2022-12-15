/// Describes API notes data for any entity, i.e. a type that can be renamed
/// from its definition in the C language into a more appropriate name in the
/// Swift language or even hidden from the interface.
///
/// This is used as the base of all API notes.
public protocol Entity {
  /// The original name of the definition (in C language)
  var name: String { get }

  /// The more appropriate name in Swift language.
  /// Equivalent to NS_SWIFT_NAME.
  var swiftName: String? { get }

  /// Whether this entity is considered "private" to a Swift overlay.
  /// Equivalent to NS_REFINED_FOR_SWIFT.
  var isSwiftPrivate: Bool? { get }

  /// Specifies which platform the API is available on.
  var availability: Availability? { get }
}

// MARK: - Codable Support
private enum EntityCodingKeys: String, CodingKey {
  case name = "Name"
  case swiftName = "SwiftName"
  case isSwiftPrivate = "SwiftPrivate"
}

extension Entity {
  /// A support function to decode all entity related values
  static internal func decodeEntity(from decoder: Decoder) throws -> (
    name: String,
    swiftName: String?,
    isSwiftPrivate: Bool?,
    availability: Availability?
  ) {
    let container = try decoder.container(keyedBy: EntityCodingKeys.self)
    let name = try container.decode(String.self, forKey: .name)
    let swiftName = try container.decodeIfPresent(
      String.self, forKey: .swiftName
    )
    let isSwiftPrivate = try container.decodeIfPresent(
      Bool.self, forKey: .isSwiftPrivate
    )
    let availability = try Availability.decodeAvailabilityIfPresent(
      from: decoder
    )
    return (name, swiftName, isSwiftPrivate, availability)
  }

  /// A support function to encode all entity related values
  internal func encodeEntity(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: EntityCodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(swiftName, forKey: .swiftName)
    try container.encodeIfPresent(isSwiftPrivate, forKey: .isSwiftPrivate)
    try availability?.encode(to: encoder)
  }
}
