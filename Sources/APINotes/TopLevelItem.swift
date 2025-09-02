import MetaCodable

@Codable
public struct TopLevelItems {
    @CodedAt("Tags")
    public var tags: [Tag]?

    @CodedAt("Typedefs")
    public var typedefs: [Typedef]?

    @CodedAt("Globals")
    public var globals: [Variable]?

    @CodedAt("Enumerators")
    public var enumerators: [Enumerator]?

    @CodedAt("Functions")
    public var functions: [Function]?

    @CodedAt("Classes")
    public var classes: [ObjCContext]?

    @CodedAt("Protocols")
    public var protocols: [ObjCContext]?

    /// Creates a new instance from given values
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
