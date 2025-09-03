import MetaCodable

/// Describes API notes data for a typedef.
@Codable
public final class Typedef: CommonType {
    @CodedAt("SwiftWrapper")
    public var swiftWrapper: SwiftWrapper?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil,
        swiftWrapper: SwiftWrapper? = nil
    ) {
        self.swiftWrapper = swiftWrapper
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
