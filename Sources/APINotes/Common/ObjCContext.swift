import MetaCodable

@Codable
public class ObjCContext: CommonType {
    @CodedAt("Methods")
    @Default([])
    var methods: [ObjCMethod]
    @CodedAt("Properties")
    @Default([])
    var properties: [ObjCProperty]
}
