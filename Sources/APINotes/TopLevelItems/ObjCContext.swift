import MetaCodable

@Codable
public class ObjCContext: CommonType {
    @CodedAt("Methods")
    var methods: [ObjCMethod]?

    @CodedAt("Properties")
    var properties: [ObjCProperty]?

    init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        swiftBridge: String? = nil,
        errorDomain: String? = nil,
        methods: [ObjCMethod]? = nil,
        properties: [ObjCProperty]? = nil
    ) {
        self.methods = methods
        self.properties = properties
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

@Codable
public final class ObjCClass: ObjCContext {}

@Codable
public final class ObjCProtocol: ObjCContext {}
