/// Describes API notes for types.
public class TypeInfo: Entity {
  /// The Swift type to which a given type is bridged.
  ///
  /// Reflects the swift_bridge attribute. Used for Objective-C class types
  /// bridged to Swift value types. An empty string (“”) means a type is not
  /// bridged. Not supported outside of Apple frameworks (the Swift side of it
  /// requires conforming to implementation-detail protocols that are
  /// subject to change).
  ///
  ///     - Name: NSIndexSet
  ///       SwiftBridge: IndexSet
  public let swiftBridge: String?

  /// The NSError domain for this type. Used for NSError code enums
  ///
  /// The value is the name of the associated domain NSString constant;
  /// an empty string ("") means the enum is a normal enum rather
  /// than an error code.
  ///
  ///     - Name: MKErrorCode
  ///       NSErrorDomain: MKErrorDomain
  public let errorDomain: String?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    swiftBridge: String? = nil,
    errorDomain: String? = nil
  ) {
    self.swiftBridge = swiftBridge
    self.errorDomain = errorDomain
    super.init(
      name: name,
      swiftName: swiftName,
      isSwiftPrivate: isSwiftPrivate,
      availability: availability
    )
  }

  // MARK: - Conformance to Hashable

  public static func == (lhs: TypeInfo, rhs: TypeInfo) -> Bool {
    lhs as Entity == rhs as Entity &&
    lhs.swiftBridge == rhs.swiftBridge &&
    lhs.errorDomain == rhs.errorDomain
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(swiftBridge)
    hasher.combine(errorDomain)
  }

  // MARK: - Conformance to Codable

  private enum CodingKeys: String, CodingKey {
    case swiftBridge = "SwiftBridge"
    case errorDomain = "NSErrorDomain"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    swiftBridge = try container.decodeIfPresent(
      String.self, forKey: .swiftBridge
    )
    errorDomain = try container.decodeIfPresent(
      String.self, forKey: .errorDomain
    )
    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(swiftBridge, forKey: .swiftBridge)
    try container.encodeIfPresent(errorDomain, forKey: .errorDomain)
    try super.encode(to: encoder)
  }
}
