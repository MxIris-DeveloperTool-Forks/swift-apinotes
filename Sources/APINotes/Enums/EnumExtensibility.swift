/// Defines the C enumeration kind (is it a bitmask, or closed enum)
///
/// The payload for an enum_extensibility attribute.
public enum EnumExtensibility: String, Codable {
    /// Defines an open or extensible enumeration
    case open
    /// Defines a closed or not extensible enumeration
    case closed
    /// Indicates auditing
    case none // none
}
