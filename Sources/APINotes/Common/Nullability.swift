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
  // Equivalent of _Nonnull
  case nonnull // Scalar, S, Nonnull or N
  // Equivalent of _Nullable
  case optional // Optional or O
  // Equivalent of _Null_unspecified
  case unspecified // Unspecified or U
}

// MARK: - Conformance to Codable
extension Nullability: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    switch rawValue {
    case "Scalar", "S": // Scalar is deprecated, routes through Nonnull instead
      fallthrough
    case "Nonnull", "N":
      self = .nonnull
    case "Optional", "O":
      self = .optional
    case "Unspecified", "U":
      self = .unspecified
    default:
      throw DecodingError.typeMismatch(
        Nullability.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "\(rawValue) is not a Nullability specifier"
        ))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .nonnull: try container.encode("Nonnull")
    case .optional: try container.encode("Optional")
    case .unspecified: try container.encode("Unspecified")
    }
  }
}
