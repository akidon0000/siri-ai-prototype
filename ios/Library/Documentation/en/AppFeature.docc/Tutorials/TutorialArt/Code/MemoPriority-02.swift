import AppIntents

// As an AppEnum, Siri picks a value from a fixed set of choices. It can also go in phrases
enum MemoPriority: String, AppEnum {
    case low, normal, high

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Priority"
}
