import Foundation

public struct TypeKey: Hashable {
    public let type: Any.Type

    init(type: Any.Type) {
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    public static func ==(lhs: TypeKey, rhs: TypeKey) -> Bool {
        lhs.type == rhs.type
    }
}
