extension Module {
  public struct TopLevelItems: Hashable {

    public var tags: [Tag]?

    public var typedefs: [Typedef]?

    public var globals: [Variable]?

    public var enumerators: [Enumerator]?

    public var functions: [Function]?

    public init(
      tags: [Tag]? = nil,
      typedefs: [Typedef]? = nil,
      globals: [Variable]? = nil,
      enumerators: [Enumerator]? = nil,
      functions: [Function]? = nil
    ) {
      self.tags = tags
      self.typedefs = typedefs
      self.globals = globals
      self.enumerators = enumerators
      self.functions = functions
    }
  }
}

// MARK: - Conformance to Encodable + Decodable Support
extension Module.TopLevelItems: Encodable {
  private enum CodingKeys: String, CodingKey {
    case tags = "Tags"
    case typedefs = "Typedefs"
    case globals = "Globals"
    case enumerators = "Enumerators"
    case functions = "Functions"
    case classes = "Classes"
    case protocols = "Protocols"
  }

  internal static func decodeTopLevelItemsIfPresent(
    from decoder: Decoder
  ) throws -> Module.TopLevelItems? {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let tags = try container.decodeIfPresent([Tag].self, forKey: .tags)
    let typedefs = try container.decodeIfPresent(
      [Typedef].self, forKey: .typedefs)
    let globals = try container.decodeIfPresent(
      [Variable].self, forKey: .globals)
    let enumerators = try container.decodeIfPresent(
      [Enumerator].self, forKey: .enumerators)
    let functions = try container.decodeIfPresent(
      [Function].self, forKey: .functions)

    // Only return an instance if any value is present
    guard
      tags != .none ||
      typedefs != .none ||
      globals != .none ||
      enumerators != .none ||
      functions != .none
    else { return nil }
    return Module.TopLevelItems(
      tags: tags,
      typedefs: typedefs,
      globals: globals,
      enumerators: enumerators,
      functions: functions
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(tags, forKey: .tags)
    try container.encodeIfPresent(typedefs, forKey: .typedefs)
    try container.encodeIfPresent(globals, forKey: .globals)
    try container.encodeIfPresent(enumerators, forKey: .enumerators)
    try container.encodeIfPresent(functions, forKey: .functions)
  }
}
