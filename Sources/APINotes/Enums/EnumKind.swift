public enum EnumKind: String, Codable {
    case nsEnum = "NSEnum"
    case cfEnum = "CFEnum"
    case nsOptions = "NSOptions"
    case cfOptions = "CFOptions"
    case nsClosedEnum = "NSClosedEnum"
    case cfClosedEnum = "CFClosedEnum"
    case none
}
