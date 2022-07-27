/// Specifies which platform the API is available on.
public enum Availability: Hashable {
  /// Exclusively availabilty to macOS
  case macOS
  /// Exclusively availabilty to iOS
  case iOS
  /// Can be used in the "SwiftVersions" section to undo the
  /// effect of `nonswift`.
  case available
  /// Not available in any source code
  ///
  /// - Parameter message: Message to show at the diagnostics
  /// level when this entity is accessed but unavailable.
  case none(message: String?)
  /// Not available in Swift source code.
  /// Equivalent to NS_SWIFT_UNAVAILABLE
  ///
  /// - Parameter message: Message to show at the diagnostics
  /// level when this entity is accessed but unavailable.
  case nonswift(message: String?)
}

// MARK: - Conformance to Encodable + Decodable Support
extension Availability: Encodable {
  /// Specifies the keys used for encoding and decoding
  private enum CodingKeys: String, CodingKey {
    case availability = "Availability"
    case message = "AvailabilityMsg"
  }

  internal static func decodeAvailabilityIfPresent(
    from decoder: Decoder
  ) throws -> Availability? {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decodeIfPresent(String.self, forKey: .availability)
    let message = try container.decodeIfPresent(String.self, forKey: .message)
    switch type {
    case "OSX": return .macOS
    case "iOS": return .iOS
    case "available": return .available
    case "none": return .none(message: message)
    case "nonswift": return .nonswift(message: message)
    default: return nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    let availability: String? = {
      switch self {
      case .macOS: return "OSX"
      case .iOS: return "iOS"
      case .available: return "available"
      case .none: return "none"
      case .nonswift: return "nonswift"
      }
    }()

    let message: String? = {
      switch self {
      case let .none(message): return message
      case let .nonswift(message): return message
      default: return nil
      }
    }()

    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(availability, forKey: .availability)
    try container.encodeIfPresent(message, forKey: .message)
  }
}
