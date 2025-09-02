import MetaCodable

@Codable
public struct Module {
    /// The name of the module (the framework name, for frameworks).
    /// Note that this is always the name of a top-level module, even within a
    /// private API notes file.
    @CodedAt("Name")
    public var name: String

    /// Specifies which platform or language the API is available on
    @CodedAt
    @Default(Availability?.none)
    public var availability: Availability?

    @CodedAt("SwiftInferImportAsMember")
    public var inferImportAsMember: Bool?

    /// The non-version top level items definition
    @CodedAt
    @Default(TopLevelItems?.none)
    public var items: TopLevelItems?

    /// The versioned top level items definitions
    @CodedAt("SwiftVersions")
    public var versions: [Version]?

    /// Creates a new instance from given values
    public init(
        name: String,
        availability: Availability? = nil,
        inferImportAsMember: Bool? = nil,
        items: TopLevelItems? = nil,
        versions: [Version]? = nil
    ) {
        self.name = name
        self.availability = availability
        self.inferImportAsMember = inferImportAsMember
        self.items = items
        self.versions = versions
    }
}
