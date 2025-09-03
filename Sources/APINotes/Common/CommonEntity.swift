import MetaCodable

private struct NameCoder: HelperCoder {
    typealias Coded = String

    func decode(from decoder: any Decoder) throws -> String {
        guard let value = try? String(from: decoder) else { return "" }
        return value
    }

    func encode(_ value: String, to encoder: any Encoder) throws {
        guard !value.isEmpty else { return }
        try value.encode(to: encoder)
    }
    
    func decode<DecodingContainer>(from container: DecodingContainer, forKey key: DecodingContainer.Key) throws -> String where DecodingContainer : KeyedDecodingContainerProtocol {
        guard let value = try? container.decode(String.self, forKey: key) else { return "" }
        return value
    }
    
    func encode<EncodingContainer>(_ value: String, to container: inout EncodingContainer, atKey key: EncodingContainer.Key) throws where EncodingContainer : KeyedEncodingContainerProtocol {
        guard !value.isEmpty else { return }
        try container.encode(value, forKey: key)
    }
}

@Codable
@Inherits(decodable: false, encodable: false)
public class CommonEntity {
    @CodedAt("Name")
    @CodedBy(NameCoder())
    public var name: String

    @CodedAt("SwiftName")
    public var swiftName: String?

    @CodedAt("SwiftPrivate")
    public var isSwiftPrivate: Bool?

    @CodedAt("Availability")
    public var availability: Availability?

    @CodedAt("AvailabilityMsg")
    public var availabilityMessage: String?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        availabilityMessage: String? = nil
    ) {
        self.name = name
        self.swiftName = swiftName
        self.isSwiftPrivate = isSwiftPrivate
        self.availability = availability
        self.availabilityMessage = availabilityMessage
    }
}
