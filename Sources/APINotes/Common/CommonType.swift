import MetaCodable

@Codable
public class CommonType: CommonEntity {
    @CodedAt("SwiftBridge")
    public var swiftBridge: String?
    @CodedAt("NSErrorDomain")
    public var errorDomain: String?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil
    ) {
        self.swiftBridge = swiftBridge
        self.errorDomain = errorDomain
        super.init(
            name: name,
            swiftName: swiftName,
            isSwiftPrivate: isSwiftPrivate,
            availability: availability
        )
    }
}
