import MetaCodable

@Codable
public struct Version {
    /// The version number which these attributes apply to
    @CodedAt("Version")
    public var version: Tuple

    /// The attributes that apply to this specific version
    @CodedAt
    public var items: TopLevelItems

    /// Creates a new instance from given values
    public init(
        version: Tuple,
        items: TopLevelItems
    ) {
        self.version = version
        self.items = items
    }
}
