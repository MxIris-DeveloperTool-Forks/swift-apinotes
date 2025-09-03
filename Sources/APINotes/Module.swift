import Foundation
private import MetaCodable
private import Yams

@Codable
@MemberInit
public struct Module {
    /// The name of the module (the framework name, for frameworks).
    /// Note that this is always the name of a top-level module, even within a
    /// private API notes file.
    @CodedAt("Name")
    public var name: String

    /// The versioned top level items definitions
    @CodedAt("SwiftVersions")
    public var versions: [Version]?

    /// Specifies which platform or language the API is available on
    @CodedAt("Availability")
    public var availability: Availability?

    @CodedAt("AvailabilityMsg")
    public var availabilityMessage: String?

    @CodedAt("SwiftInferImportAsMember")
    public var inferImportAsMember: Bool?

    @CodedAt("Classes")
    public var classes: [ObjCClass]?

    @CodedAt("Protocols")
    public var protocols: [ObjCProtocol]?
    
    @CodedAt("Tags")
    public var tags: [Tag]?

    @CodedAt("Typedefs")
    public var typedefs: [Typedef]?

    @CodedAt("Globals")
    public var globals: [Variable]?

    @CodedAt("Enumerators")
    public var enumerators: [Enumerator]?

    @CodedAt("Functions")
    public var functions: [Function]?
    
    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = YAMLDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    public func write(to url: URL) throws {
        try stringValue.write(to: url, atomically: true, encoding: .utf8)
    }

    public var stringValue: String {
        get throws {
            let encoder = YAMLEncoder()
            encoder.options.explicitStart = true
            return try encoder.encode(self)
        }
    }
}
