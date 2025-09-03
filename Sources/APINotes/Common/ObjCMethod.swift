import MetaCodable

@Codable
public final class ObjCMethod: Function {
    @CodedAt("Selector")
    public var selector: String

    @CodedAt("MethodKind")
    public var kind: ObjCMemberKind
    
    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        parameters: [IndexedParameter]? = nil,
        nullabilityOfParameters: [Nullability]? = nil,
        resultType: String? = nil,
        nullabilityOfResult: Nullability? = nil,
        selector: String,
        kind: ObjCMemberKind,
    ) {
        self.selector = selector
        self.kind = kind
        super.init(
            name: name,
            swiftName: swiftName,
            isSwiftPrivate: isSwiftPrivate,
            availability: availability,
            parameters: parameters,
            nullabilityOfParameters: nullabilityOfParameters,
            resultType: resultType,
            nullabilityOfResult: nullabilityOfResult
        )
    }
}
