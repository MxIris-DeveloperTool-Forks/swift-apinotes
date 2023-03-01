/// Describes a function parameter.
///
///     - Name: "isEqual:"
///       Parameters:
///       - Position: 0
///         Nullability: O
public struct Function: Entity, Hashable {
  /// Describes a function parameter and its position
  public struct IndexedParameter: Hashable {
    /// Describes the level of detail of the function parameter specification
    public enum Specification: Hashable {
      /// Full parameter specification available
      case parameter(_ value: Variable, isNoneEscaping: Bool? = nil)
      /// Only audited for nullability and eventually escaping
      case nullability(_ value: Nullability, isNoneEscaping: Bool? = nil)
      /// Only audited for escaping
      case isNoneEscaping(_ value: Bool)
    }

    /// The function parameter position
    public var position: Int

    /// The level of detail of the specification
    public var specification: Specification

    // Creates a new parameter from given values
    public init(position: Int, specification: Specification) {
      self.position = position
      self.specification = specification
    }
  }

  public var name: String

  public var swiftName: String?

  public var isSwiftPrivate: Bool?

  public var availability: Availability?

  /// The function parameters, referenced by their 0-based `Position`
  public var parameters: [IndexedParameter]?

  /// Nullability of the parameters, unless otherwise specified in `parameters`
  public var nullabilityOfParameters: [Nullability]?

  /// The result type of this function, as a C type
  public var resultType: String?

  /// Nullability of the result
  public var nullabilityOfResult: Nullability?

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
    self.name = name
    self.swiftName = swiftName
    self.isSwiftPrivate = isSwiftPrivate
    self.availability = availability
    self.parameters = parameters
    self.nullabilityOfParameters = nullabilityOfParameters
    self.resultType = resultType
    self.nullabilityOfResult = nullabilityOfResult
  }
}

// MARK: - Conformance to Codable
extension Function: Codable {
  private enum CodingKeys: String, CodingKey {
    case parameters = "Parameters"
    case nullabilityOfParameters = "Nullability"
    case resultType = "ResultType"
    case nullabilityOfResult = "NullabilityOfRet"
  }

  public init(from decoder: Decoder) throws {
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
    (name, swiftName, isSwiftPrivate, availability) = try Self.decodeEntity(
      from: decoder
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(parameters, forKey: .parameters)
    try container.encodeIfPresent(
      nullabilityOfParameters, forKey: .nullabilityOfParameters
    )
    try container.encodeIfPresent(resultType, forKey: .resultType)
    try container.encodeIfPresent(
      nullabilityOfResult, forKey: .nullabilityOfResult
    )
    try encodeEntity(to: encoder)
  }
}

// MARK: - IndexedParameter Conformance to Codable
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
    if let parameter = try? Variable(from: decoder) {
      specification = .parameter(parameter, isNoneEscaping: isNoneEscaping)
    } else if let nullability = nullability {
      specification = .nullability(nullability, isNoneEscaping: isNoneEscaping)
    } else if let isNoneEscaping = isNoneEscaping {
      specification = .isNoneEscaping(isNoneEscaping)
    } else {
      throw DecodingError.valueNotFound(Self.self, DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Neither Variable, Nullability nor Escaping specified"
      ))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(position, forKey: .position)
    switch specification {
    case let .parameter(variable, isNoneEscaping):
      try variable.encode(to: encoder)
      try container.encodeIfPresent(isNoneEscaping, forKey: .isNoneEscaping)
    case let .nullability(nullability, isNoneEscaping):
      try container.encode(nullability, forKey: .nullability)
      try container.encodeIfPresent(isNoneEscaping, forKey: .isNoneEscaping)
    case let .isNoneEscaping(isNoneEscaping):
      try container.encode(isNoneEscaping, forKey: .isNoneEscaping)
    }
  }
}
