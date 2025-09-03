private import MetaCodable

@Codable
@MemberInit
public struct Version {
    /// The version number which these attributes apply to
    @CodedAt("Version")
    public var version: Tuple

    @CodedAt("Classes")
    public var classes: [ObjCClass]?

    @CodedAt("Protocols")
    public var protocols: [ObjCProtocol]?

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
}
