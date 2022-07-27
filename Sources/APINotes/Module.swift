public struct Module: Hashable {
  /// The name of the module (the framework name, for frameworks).
  /// Note that this is always the name of a top-level module, even within a
  /// private API notes file.
  public var name: String
  /// Specifies which platform or language the API is available on
  public var availability: Availability?

  public var inferImportAsMember: Bool?

  /// The non-version top level items definition
  public var items: TopLevelItems?

  /// The versioned top level items definitions
  public var versions: [Version]?
}

// MARK: - Conformance to Codable
extension Module: Codable {
  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case inferImportAsMember = "SwiftInferImportAsMember"
    case versions = "SwiftVersions"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    availability = try Availability.decodeAvailabilityIfPresent(
      from: decoder)
    inferImportAsMember = try container.decodeIfPresent(
      Bool.self, forKey: .inferImportAsMember)
    items = try TopLevelItems.decodeTopLevelItemsIfPresent(
      from: decoder)
    versions = try container.decodeIfPresent(
      [Version].self, forKey: .versions)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(
      inferImportAsMember, forKey: .inferImportAsMember)
    try container.encodeIfPresent(
      versions, forKey: .versions)
    try items?.encode(to: encoder)
    try availability?.encode(to: encoder)
  }
}
