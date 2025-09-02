import MetaCodable

@Codable
public class ObjCMethod: Function {
    @CodedAt("Selector")
    @Default("")
    public var selector: String

    @CodedAt("MethodKind")
    public var kind: ObjCMemberKind?
}
