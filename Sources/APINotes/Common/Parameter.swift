private import MetaCodable

@Codable
public class Parameter: Variable {
    @CodedAt("NoEscape")
    public var isNoEscape: Bool?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        type: String? = nil,
        nullability: Nullability? = nil,
        isNoEscape: Bool? = nil,
    ) {
        self.isNoEscape = isNoEscape
        super.init(name: name, swiftName: swiftName, isSwiftPrivate: isSwiftPrivate, availability: availability, type: type, nullability: nullability)
    }
}
