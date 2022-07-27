extension Module {
  public struct Version: Hashable {

    public var version: VersionTuple

    public var items: TopLevelItems

    public init(
      version: VersionTuple,
      items: TopLevelItems
    ) {
      self.version = version
      self.items = items
    }
  }
}

// MARK: - Conformance to Codable
extension Module.Version: Codable {
  private enum CodingKeys: String, CodingKey {
    case version = "Version"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    version = try container.decode(VersionTuple.self, forKey: .version)
    guard let items = try Module.TopLevelItems.decodeTopLevelItemsIfPresent(
      from: decoder
    ) else {
      throw DecodingError.valueNotFound(
        Module.TopLevelItems.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription:
            "Items in Version \(version) are not present or failed decoded"
        )
      )
    }
    self.items = items
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(version, forKey: .version)
    try items.encode(to: encoder)
  }
}
