import MetaCodable

@Codable
public class ObjCProperty: Variable {
    @CodedAt("SwiftImportAsAccessors")
    public var swiftImportAsAccessor: Bool?

    @CodedAt("PropertyKind")
    public var kind: ObjCMemberKind?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        type: String? = nil,
        nullability: Nullability? = nil,
        swiftImportAsAccessor: Bool? = nil
    ) {
        self.swiftImportAsAccessor = swiftImportAsAccessor
        super.init(name: name, swiftName: swiftName, isSwiftPrivate: isSwiftPrivate, availability: availability, type: type, nullability: nullability)
    }
}
