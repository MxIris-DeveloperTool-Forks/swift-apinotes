import MetaCodable

@Codable
@Inherits(decodable: false, encodable: false)
public class CommonEntity {
    @CodedAt("Name")
    @Default("")
    public var name: String
    @CodedAt("SwiftName")
    public var swiftName: String?
    @CodedAt("SwiftPrivate")
    public var isSwiftPrivate: Bool?
    @CodedAt
    @Default(Availability?.none)
    public var availability: Availability?

    public init(name: String, swiftName: String? = nil, isSwiftPrivate: Bool? = nil, availability: Availability? = nil) {
        self.name = name
        self.swiftName = swiftName
        self.isSwiftPrivate = isSwiftPrivate
        self.availability = availability
    }
}
