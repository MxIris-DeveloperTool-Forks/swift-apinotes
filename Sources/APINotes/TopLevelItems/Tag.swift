import MetaCodable

/// Describes API notes data for a tag.
@Codable
public class Tag: CommonType {
    /// Defines the C enumeration kind (is it a bitmask, or closed enum)
    ///
    /// The payload for an enum_extensibility attribute.
    public enum EnumerationExtensibility {
        /// Defines an open or extensible enumeration
        case open(isFlagEnum: Bool)
        /// Defines a closed or not extensible enumeration
        case closed(isFlagEnum: Bool)
        /// Indicates auditing
        case none // none
    }

    /// The kind of enumeration if this tag is an enumeration
    @CodedAt
    @Default(EnumerationExtensibility?.none)
    public var extensibility: EnumerationExtensibility?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil,
        extensibility: EnumerationExtensibility? = nil
    ) {
        self.extensibility = extensibility
        super.init(
            name: name,
            swiftName: swiftName,
            isSwiftPrivate: isSwiftPrivate,
            availability: availability,
            swiftBridge: swiftBridge,
            errorDomain: errorDomain
        )
    }
}

// MARK: - Convenience Enum Kind

/// Syntactic sugar for Extensibility and Flag Enumeration
extension Tag.EnumerationExtensibility {
    /// EnumExtensibility: open, FlagEnum: false
    public static var coreFoundationEnum: Self {
        .open(isFlagEnum: false)
    }

    /// EnumExtensibility: closed, FlagEnum: false
    public static var coreFoundationClosedEnum: Self {
        .closed(isFlagEnum: false)
    }

    /// EnumExtensibility: open, FlagEnum: true
    public static var coreFoundationOptions: Self {
        .open(isFlagEnum: true)
    }
}

// MARK: - Codable Support

extension Optional where Wrapped == Tag.EnumerationExtensibility {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Tag.EnumerationExtensibility.CodingKeys.self)
        switch self {
        case .open(let isFlagEnum):
            try container.encode("open", forKey: .enumExtensibility)
            try container.encode(isFlagEnum, forKey: .flagEnum)
        case .closed(let isFlagEnum):
            try container.encode("closed", forKey: .enumExtensibility)
            try container.encode(isFlagEnum, forKey: .flagEnum)
        case .some(.none):
            try container.encode("none", forKey: .enumExtensibility)
        default: break
        }
    }
}

extension Tag.EnumerationExtensibility: Codable {
    fileprivate enum CodingKeys: String, CodingKey {
        case enumExtensibility = "EnumExtensibility"
        case flagEnum = "FlagEnum"
        case enumKind = "EnumKind"
    }

    public init(from decoder: any Decoder) throws {
        // Try decoding the "complete" definition of enum + flag first, and only
        // if it fails then fallback to the convenience kind decoding.
        if let extensibility = try Self.extensibility(from: decoder) {
            self = extensibility
        } else if let extensibility = try Self.enumerationKind(from: decoder) {
            self = extensibility
        } else {
            throw DecodingError.valueNotFound(
                Tag.EnumerationExtensibility.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Neither EnumExtensibility nor EnumKind were found"
                )
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .open(let isFlagEnum):
            try container.encode("open", forKey: .enumExtensibility)
            try container.encode(isFlagEnum, forKey: .flagEnum)
        case .closed(let isFlagEnum):
            try container.encode("closed", forKey: .enumExtensibility)
            try container.encode(isFlagEnum, forKey: .flagEnum)
        default: break
        }
    }

    fileprivate static func extensibility(
        from decoder: Decoder
    ) throws -> Tag.EnumerationExtensibility? {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let extensibility = try container.decodeIfPresent(
            String.self, forKey: .enumExtensibility
        ) else { return nil }

        switch extensibility {
        case "open":
            let isFlagEnum = try container.decode(Bool.self, forKey: .flagEnum)
            return .open(isFlagEnum: isFlagEnum)
        case "closed":
            let isFlagEnum = try container.decode(Bool.self, forKey: .flagEnum)
            return .closed(isFlagEnum: isFlagEnum)
        case "none":
            return Tag.EnumerationExtensibility.none
        default:
            throw DecodingError.typeMismatch(
                Tag.EnumerationExtensibility.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "\(extensibility) is not a valid enumeration " +
                        "extensibility. Use either none, open or closed"
                )
            )
        }
    }

    fileprivate static func enumerationKind(
        from decoder: Decoder
    ) throws -> Tag.EnumerationExtensibility? {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let enumKind = try container.decodeIfPresent(
            String.self, forKey: .enumKind
        ) else { return nil }

        switch enumKind {
        case "NSEnum",
             "CFEnum":
            return .coreFoundationEnum
        case "NSClosedEnum",
             "CFClosedEnum":
            return .coreFoundationClosedEnum
        case "NSOptions",
             "CFOptions":
            return .coreFoundationOptions
        case "none":
            return Tag.EnumerationExtensibility.none
        default:
            throw DecodingError.typeMismatch(
                Tag.EnumerationExtensibility.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "\(enumKind) is not a valid convenience " +
                        "enumeration kind. Use either NSEnum (or CFEnum), " +
                        "NSClosedEnum (or CFClosedEnum) or NSOptions (or CFOptions)"
                )
            )
        }
    }
}
