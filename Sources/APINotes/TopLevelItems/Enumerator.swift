/// Describes API notes data for an enumerator.
///
/// Enumerators refer to enum cases.
public struct Enumerator: Entity, Hashable {
  public var name: String

  public var swiftName: String?

  public var isSwiftPrivate: Bool?

  public var availability: Availability?

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
}

// MARK: - Conformance to Codable
extension Enumerator: Codable {
  public init(from decoder: Decoder) throws {
    (name, swiftName, isSwiftPrivate, availability) = try Self.decodeEntity(
      from: decoder
    )
  }

  public func encode(to encoder: Encoder) throws {
    try encodeEntity(to: encoder)
  }
}
