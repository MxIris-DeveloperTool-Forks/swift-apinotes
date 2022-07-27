/// Describes a function parameter.
///
///     - Name: "isEqual:"
///       Parameters:
///       - Position: 0
///         Nullability: O
public final class Function: Entity {
  /// Describes a function parameter and its position
  public struct IndexedParameter: Hashable {
    /// Describes the level of detail of the function parameter specification
    public enum Specification: Hashable {
      /// Full parameter specification available
      case parameter(_ value: Parameter)
      /// Only audited for nullability and (optionally) escaping
      case nullability(_ value: Nullability, isNoneEscaping: Bool? = nil)
      /// Only audited for escaping
      case isNoneEscaping(_ value: Bool)
    }

    /// The function parameter position
    public var position: Int

    /// The level of detail of the specification
    public var specification: Specification
  }

  /// The function parameters, referenced by their 0-based `Position`
  public let parameters: [IndexedParameter]?

  /// Nullability of the parameters, unless otherwise specified in `parameters`
  public let nullabilityOfParameters: [Nullability]?

  /// The result type of this function, as a C type
  public let resultType: String?

  /// Nullability of the result
  public let nullabilityOfResult: Nullability?

  /// Creates a new instance from given values
  public init(
    name: String,
    swiftName: String? = nil,
    isSwiftPrivate: Bool? = nil,
    availability: Availability? = nil,
    parameters: [IndexedParameter]? = nil,
    nullabilityOfParameters: [Nullability]? = nil,
    resultType: String? = nil,
    nullabilityOfResult: Nullability? = nil
  ) {
    self.parameters = parameters
    self.nullabilityOfParameters = nullabilityOfParameters
    self.resultType = resultType
    self.nullabilityOfResult = nullabilityOfResult
    super.init(
      name: name,
      swiftName: swiftName,
      isSwiftPrivate: isSwiftPrivate,
      availability: availability
    )
  }

  // MARK: - Conformance to Hashable

  public static func == (lhs: Function, rhs: Function) -> Bool {
    lhs as Entity == rhs as Entity &&
    lhs.parameters == rhs.parameters &&
    lhs.nullabilityOfParameters == rhs.nullabilityOfParameters &&
    lhs.resultType == rhs.resultType &&
    lhs.nullabilityOfResult == rhs.nullabilityOfResult
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(parameters)
    hasher.combine(nullabilityOfParameters)
    hasher.combine(resultType)
    hasher.combine(nullabilityOfResult)
  }

  // MARK: - Conformance to Codable

  private enum CodingKeys: String, CodingKey {
    case parameters = "Parameters"
    case nullabilityOfParameters = "Nullability"
    case resultType = "ResultType"
    case nullabilityOfResult = "NullabilityOfRet"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    parameters = try container.decodeIfPresent(
      [IndexedParameter].self, forKey: .parameters
    )
    nullabilityOfParameters = try container.decodeIfPresent(
      [Nullability].self, forKey: .nullabilityOfParameters
    )
    resultType = try container.decodeIfPresent(
      String.self, forKey: .resultType
    )
    nullabilityOfResult = try container.decodeIfPresent(
      Nullability.self, forKey: .nullabilityOfResult
    )
    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(parameters, forKey: .parameters)
    try container.encodeIfPresent(
      nullabilityOfParameters, forKey: .nullabilityOfParameters
    )
    try container.encodeIfPresent(resultType, forKey: .resultType)
    try container.encodeIfPresent(
      nullabilityOfResult, forKey: .nullabilityOfResult
    )
    try super.encode(to: encoder)
  }
}

// MARK: - IndexedParameter Codable Support
extension Function.IndexedParameter: Codable {
  private enum CodingKeys: String, CodingKey {
    case position = "Position"
    case nullability = "Nullability"
    case isNoneEscaping = "NoEscape"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    position = try container.decode(Int.self, forKey: .position)
    let nullability = try container.decodeIfPresent(
      Nullability.self, forKey: .nullability)
    let isNoneEscaping = try container.decodeIfPresent(
      Bool.self, forKey: .isNoneEscaping)
    if let parameter = try? Function.Parameter(from: decoder) {
      specification = .parameter(parameter)
    } else if let nullability = nullability {
      specification = .nullability(nullability, isNoneEscaping: isNoneEscaping)
    } else if let isNoneEscaping = isNoneEscaping {
      specification = .isNoneEscaping(isNoneEscaping)
    } else {
      throw DecodingError.valueNotFound(
        Function.Parameter.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription:
            "Neither Parameter, Nullability nor Escaping specified"
        ))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(position, forKey: .position)
    switch specification {
    case let .parameter(parameter):
      try parameter.encode(to: encoder)
    case let .nullability(nullability, isNoneEscaping):
      try container.encode(nullability, forKey: .nullability)
      try container.encodeIfPresent(isNoneEscaping, forKey: .isNoneEscaping)
    case let .isNoneEscaping(isNoneEscaping):
      try container.encode(isNoneEscaping, forKey: .isNoneEscaping)
    }
  }
}
