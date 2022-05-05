import Foundation

public struct Hela {
    internal static var registry: TypeRegistry?

    public static var isTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    @discardableResult
    public static func preconditionFailure<T>(_ message: @autoclosure () -> String = String(),
                                              file: StaticString = #file,
                                              line: UInt = #line) -> T {
        guard isTesting, let registry = registry else {
            Swift.preconditionFailure(message(), file: file, line: line)
        }
        do {
            return try registry.get(type: T.self)
        } catch {
            fatalError("Error: \(error)")
        }
    }

}
