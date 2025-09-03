private import MetaCodable

@Codable
public final class ObjCProperty: Variable {
    @CodedAt("PropertyKind")
    public var kind: ObjCMemberKind

    @CodedAt("SwiftImportAsAccessors")
    public var swiftImportAsAccessor: Bool?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        type: String? = nil,
        nullability: Nullability? = nil,
        kind: ObjCMemberKind,
        swiftImportAsAccessor: Bool? = nil,
    ) {
        self.kind = kind
        self.swiftImportAsAccessor = swiftImportAsAccessor
        super.init(name: name, swiftName: swiftName, isSwiftPrivate: isSwiftPrivate, availability: availability, type: type, nullability: nullability)
    }
}
