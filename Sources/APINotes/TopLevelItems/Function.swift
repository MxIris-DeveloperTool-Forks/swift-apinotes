import MetaCodable

/// Describes a function parameter.
///
///     - Name: "isEqual:"
///       Parameters:
///       - Position: 0
///         Nullability: O
@Codable
public class Function: CommonEntity {
    /// Describes a function parameter and its position
    @Codable
    public class IndexedParameter: Parameter {
        /// The function parameter position
        @CodedAt("Position")
        public var position: Int

        public init(
            name: String,
            swiftName: String? = nil,
            isSwiftPrivate: Bool? = nil,
            availability: Availability? = nil,
            type: String? = nil,
            nullability: Nullability? = nil,
            isNoEscape: Bool? = nil,
            position: Int,
        ) {
            self.position = position
            super.init(
                name: name,
                swiftName: swiftName,
                isSwiftPrivate: isSwiftPrivate,
                availability: availability,
                type: type,
                nullability: nullability,
                isNoEscape: isNoEscape,
            )
        }
    }

    /// The function parameters, referenced by their 0-based `Position`
    @CodedAt("Parameters")
    public var parameters: [IndexedParameter]?

    /// Nullability of the parameters, unless otherwise specified in `parameters`
    @CodedAt("Nullability")
    public var nullabilityOfParameters: [Nullability]?

    /// The result type of this function, as a C type
    @CodedAt("ResultType")
    public var resultType: String?

    /// Nullability of the result
    @CodedAt("NullabilityOfRet")
    public var nullabilityOfResult: Nullability?

    /// Creates a new instance from given values
    public init(
        name: String,
        swiftName: String? = nil,
        isSwiftPrivate: Bool? = nil,
        availability: Availability? = nil,
        parameters: [IndexedParameter]? = nil,
        nullabilityOfParameters: [Nullability]? = nil,
        resultType: String? = nil,
        nullabilityOfResult: Nullability? = nil
    ) {
        self.parameters = parameters
        self.nullabilityOfParameters = nullabilityOfParameters
        self.resultType = resultType
        self.nullabilityOfResult = nullabilityOfResult
        super.init(
            name: name,
            swiftName: swiftName,
            isSwiftPrivate: isSwiftPrivate,
            availability: availability
        )
    }
}
