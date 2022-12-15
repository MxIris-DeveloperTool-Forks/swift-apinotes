/// Describes API notes for types.
public protocol TypeInfo: Entity {
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
  var swiftBridge: String? { get }

  /// The NSError domain for this type. Used for NSError code enums
  ///
  /// The value is the name of the associated domain NSString constant;
  /// an empty string ("") means the enum is a normal enum rather
  /// than an error code.
  ///
  ///     - Name: MKErrorCode
  ///       NSErrorDomain: MKErrorDomain
  var errorDomain: String? { get }
}

// MARK: - Codable Support
private enum TypeInfoCodingKeys: String, CodingKey {
  case swiftBridge = "SwiftBridge"
  case errorDomain = "NSErrorDomain"
}

extension TypeInfo {
  static internal func decodeTypeInfo(from decoder: Decoder) throws -> (
    swiftBridge: String?,
    errorDomain: String?
  ) {
    let container = try decoder.container(keyedBy: TypeInfoCodingKeys.self)
    let swiftBridge = try container.decodeIfPresent(
      String.self, forKey: .swiftBridge
    )
    let errorDomain = try container.decodeIfPresent(
      String.self, forKey: .errorDomain
    )
    return (swiftBridge, errorDomain)
  }

  internal func encodeTypeInfo(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: TypeInfoCodingKeys.self)
    try container.encodeIfPresent(swiftBridge, forKey: .swiftBridge)
    try container.encodeIfPresent(errorDomain, forKey: .errorDomain)
  }
}
