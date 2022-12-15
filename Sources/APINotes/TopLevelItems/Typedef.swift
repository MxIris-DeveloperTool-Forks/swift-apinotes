/// Describes API notes data for a typedef.
public struct Typedef: TypeInfo, Hashable {
  /// The kind of a swift_wrapper/swift_newtype.
  public enum SwiftType: String, Codable {
    case `struct`
    case `enum`
    case none
  }

  public var name: String

  public var swiftName: String?

  public var isSwiftPrivate: Bool?

  public var availability: Availability?

  public var swiftBridge: String?

  public var errorDomain: String?

  public var swiftType: SwiftType?

  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    swiftBridge: String? = nil,
    errorDomain: String? = nil,
    swiftType: SwiftType? = nil
  ) {
    self.name = name
    self.swiftName = swiftName
    self.isSwiftPrivate = isSwiftPrivate
    self.availability = availability
    self.swiftBridge = swiftBridge
    self.errorDomain = errorDomain
    self.swiftType = swiftType
  }
}

// MARK: - Conformance to Codable
extension Typedef: Codable {
  private enum CodingKeys: String, CodingKey {
    case swiftType = "SwiftWrapper"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    swiftType = try container.decodeIfPresent(
      SwiftType.self, forKey: .swiftType
    )
    (swiftBridge, errorDomain) = try Self.decodeTypeInfo(from: decoder)
    (name, swiftName, isSwiftPrivate, availability) = try Self.decodeEntity(
      from: decoder
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(swiftType, forKey: .swiftType)
    try encodeTypeInfo(to: encoder)
    try encodeEntity(to: encoder)
  }
}
