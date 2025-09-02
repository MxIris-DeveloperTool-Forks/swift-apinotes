import MetaCodable

/// Describes API notes data for a typedef.
@Codable
public class Typedef: CommonType {
    /// The kind of a swift_wrapper/swift_newtype.
    public enum SwiftType: String, Codable {
        case `struct`
        case `enum`
        case none
    }

    @CodedAt("SwiftWrapper")
    public var swiftType: SwiftType?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil,
        swiftType: SwiftType? = nil
    ) {
        self.swiftType = swiftType
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
