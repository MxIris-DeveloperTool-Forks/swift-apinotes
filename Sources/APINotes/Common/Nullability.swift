/// Specifies which values to treat as optional values
///
/// Note that `Nullability` is overridden by `Type`, even in a
/// “SwiftVersions” section.
///
/// **Note**:
/// `Nullability` can also be used to describe the argument types of methods
///  and functions, but this usage is deprecated in favor of `Parameter`s.
///
/// **Example**:
/// ```
/// - Name: dataSource
///   Nullability: O
/// ```
public enum Nullability: Hashable {
    public enum Representation {
        case short
        case long
    }

    @available(*, deprecated, message: "Use nonnull instead")
    case scalar(representation: Representation = .long) // Scalar or S
    /// Equivalent of `_Nonnull`
    case nonnull(representation: Representation = .long) // Nonnull or N
    /// Equivalent of `_Nullable`
    case optional(representation: Representation = .long) // Optional or O
    /// Equivalent of `_Null_unspecified`
    case unspecified(representation: Representation = .long) // Unspecified or U
}

// MARK: - Conformance to RawRepresentable

extension Nullability: RawRepresentable {
    public typealias RawValue = String
    public var rawValue: String {
        switch self {
        case .scalar(let representation):
            return representation == .long ? "Scalar" : "S"
        case .nonnull(let representation):
            return representation == .long ? "Nonnull" : "N"
        case .optional(let representation):
            return representation == .long ? "Optional" : "O"
        case .unspecified(let representation):
            return representation == .long ? "Unspecified" : "U"
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
        case "Scalar",
             "S":
            self = .scalar(representation: rawValue == "S" ? .short : .long)
        case "Nonnull",
             "N":
            self = .nonnull(representation: rawValue == "N" ? .short : .long)
        case "Optional",
             "O":
            self = .optional(representation: rawValue == "O" ? .short : .long)
        case "Unspecified",
             "U":
            self = .unspecified(representation: rawValue == "U" ? .short : .long)
        default:
            return nil
        }
    }
}

// MARK: - Conformance to Codable

extension Nullability: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let nullability = Nullability(rawValue: rawValue) else {
            throw DecodingError.typeMismatch(
                Nullability.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "\(rawValue) is not a Nullability specifier"
                )
            )
        }
        self = nullability
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
