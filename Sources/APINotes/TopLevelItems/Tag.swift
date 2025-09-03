private import MetaCodable

/// Describes API notes data for a tag.
@Codable
public final class Tag: CommonType {
    /// The kind of enumeration if this tag is an enumeration
    @CodedAt("EnumExtensibility")
    public var enumExtensibility: EnumExtensibility?

    @CodedAt("FlagEnum")
    public var isFlagEnum: Bool?

    @CodedAt("EnumKind")
    public var enumKind: EnumKind?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil,
        extensibility: EnumExtensibility? = nil,
        isFlagEnum: Bool? = nil,
        enumKind: EnumKind? = nil,
    ) {
        self.enumExtensibility = extensibility
        self.isFlagEnum = isFlagEnum
        self.enumKind = enumKind
        super.init(
            name: name,
            swiftName: swiftName,
            isSwiftPrivate: isSwiftPrivate,
            availability: availability,
            swiftBridge: swiftBridge,
            errorDomain: errorDomain
        )
    }
}
