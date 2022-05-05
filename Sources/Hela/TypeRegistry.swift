import Foundation

public typealias InstanceFactory = () -> Any

public class TypeRegistry {
    public enum Failure: Error {
        case typeNotRegistered(Any.Type)
    }

    private var registry = [TypeKey: InstanceFactory]()

    public func register<T>(type: T.Type, factory: @escaping () -> T) {
        registry[TypeKey(type: type)] = factory
    }

    public func get<T>(type: T.Type) throws -> T {
        guard let factory = registry[TypeKey(type: type)],
        let instance = factory() as? T else {
            throw Failure.typeNotRegistered(type)
        }
        return instance
    }

    public func reset() {
        registry.removeAll()
    }
}
