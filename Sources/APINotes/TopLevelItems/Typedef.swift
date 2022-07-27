/// Describes API notes data for a typedef.
public final class Typedef: TypeInfo {
  /// The kind of a swift_wrapper/swift_newtype.
  public enum SwiftType: String, Codable {
    case `struct`
    case `enum`
    case none
  }
  public let swiftType: SwiftType?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    swiftBridge: String? = nil,
    errorDomain: String? = nil,
    swiftType: SwiftType? = nil
  ) {
    self.swiftType = swiftType
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

  public static func == (lhs: Typedef, rhs: Typedef) -> Bool {
    lhs as TypeInfo == rhs as TypeInfo &&
    lhs.swiftType == rhs.swiftType
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(swiftType)
  }

  // MARK: - Conformance to Codable

  private enum CodingKeys: String, CodingKey {
    case swiftType = "SwiftWrapper"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    swiftType = try container.decodeIfPresent(
      SwiftType.self, forKey: .swiftType
    )
    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(swiftType, forKey: .swiftType)
    try super.encode(to: encoder)
  }
}
