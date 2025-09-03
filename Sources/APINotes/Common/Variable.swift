private import MetaCodable

/// API notes for a variable/property.
@Codable
public class Variable: CommonEntity {
    //  /// The original name of the definition (in C language)
    //  public var name: String
    //  /// The more appropriate name in Swift language.
    //  /// Equivalent to NS_SWIFT_NAME.
    //  public var swiftName: String?
    //  /// Whether this entity is considered "private" to a Swift overlay.
    //  /// Equivalent to NS_REFINED_FOR_SWIFT.
    //  public var isSwiftPrivate: Bool?
    //  /// Specifies which platform the API is available on.
    //  public var availability: Availability?
    //  /// The C type of the variable, as a string.
    @CodedAt("Type")
    public var type: String?
    /// The kind of nullability for this property.
    /// `nil` if this variable has not been audited for nullability.
    @CodedAt("Nullability")
    public var nullability: Nullability?

    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        type: String? = nil,
        nullability: Nullability? = nil
    ) {
        self.type = type
        self.nullability = nullability
        super.init(name: name, swiftName: swiftName, isSwiftPrivate: isSwiftPrivate, availability: availability)
    }
}
