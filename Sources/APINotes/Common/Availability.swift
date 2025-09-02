/// Specifies which platform the API is available on.
public enum Availability: Codable, Hashable {
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

extension Availability {
    private enum CodingKeys: String, CodingKey {
        case availability = "Availability"
        case message = "AvailabilityMsg"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent(String.self, forKey: .availability)
        guard let type else { throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "type is nil")) }
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        switch type {
        case "OSX": self = .macOS
        case "iOS": self = .iOS
        case "available": self = .available
        case "none": self = .none(message: message)
        case "nonswift": self = .nonswift(message: message)
        default:
            throw DecodingError.typeMismatch(
                Availability.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "\(type) is not an Availability specifier"
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        let availability: String
        switch self {
        case .macOS: availability = "OSX"
        case .iOS: availability = "iOS"
        case .available: availability = "available"
        case .none: availability = "none"
        case .nonswift: availability = "nonswift"
        }

        let message: String?
        switch self {
        case .none(let msg): message = msg
        case .nonswift(let msg): message = msg
        default: message = nil
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(availability, forKey: .availability)
        try container.encodeIfPresent(message, forKey: .message)
    }
}
