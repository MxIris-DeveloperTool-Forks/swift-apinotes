/// Specifies which platform the API is available on.
public enum Availability: String, Codable, Hashable {
    /// Exclusively availabilty to macOS
    case macOS = "OSX"
    /// Exclusively availabilty to iOS
    case iOS
    /// Can be used in the "SwiftVersions" section to undo the
    /// effect of `nonswift`.
    case available
    /// Not available in any source code
    ///
    /// - Parameter message: Message to show at the diagnostics
    /// level when this entity is accessed but unavailable.
    case none
    /// Not available in Swift source code.
    /// Equivalent to NS_SWIFT_UNAVAILABLE
    ///
    /// - Parameter message: Message to show at the diagnostics
    /// level when this entity is accessed but unavailable.
    case nonswift
}
