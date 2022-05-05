import XCTest
@testable import Hela

struct Worker {
    struct Output {
        let value: String
    }
    func work(value: Int) -> Output {
        guard value < 10 else {
            return Hela.preconditionFailure("Value too high: \(value)")
        }

        return Output(value: "Value: \(value)")
    }
}

class HelaTests: XCTestCase {

    func testRunnerWithoutFatalError() throws {
            let runner = Runner()
            try XCTAssertNoThrowFatalError({ runner.run(behavior: .ok) })
    }

    func testRunnerWithFatalError() throws {
            let runner = Runner()
            try XCTAssertThrowFatalError({ runner.run(behavior: .fatalError) })
    }

    func testRunnerOnMain() throws {
        let runner = Runner()
        let exp = expectation(description: #function)
        var thrownError: Error? = nil
        DispatchQueue.global().async {
            do {
                try XCTAssertThrowFatalError({ runner.run(behavior: .dispatchPreconditionOnMain) })
            } catch {
                thrownError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        if let error = thrownError {
            throw error
        }
    }

    func testRunnerOffMain() throws {
        let runner = Runner()
        let exp = expectation(description: #function)
        var thrownError: Error? = nil
        DispatchQueue.main.async {
            do {
                try XCTAssertThrowFatalError({ runner.run(behavior: .dispatchPreconditionOffMain) })
            } catch {
                thrownError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        if let error = thrownError {
            throw error
        }
    }

    func testRunnerWithPrecondition() throws {
        let runner = Runner()
        try XCTAssertThrowFatalError({ runner.run(behavior: .precondition) })
    }

    func testRunnerWithPreconditionFailure() throws {
        let runner = Runner()
        try XCTAssertThrowFatalError({ runner.run(behavior: .preconditionFailure) })
    }

    func testPreconditionFails() throws {
        let registry = TypeRegistry()
        Hela.registry = registry
        defer {
            Hela.registry = nil
        }

        var calledCount = 0

        registry.register(type: Worker.Output.self) {
            calledCount += 1
            return Worker.Output(value: "Failed")
        }

        let worker = Worker()
        let one = worker.work(value: 1)
        let ten = worker.work(value: 10)

        XCTAssertEqual(one.value, "Value: 1")
        XCTAssertEqual(ten.value, "Failed")
        XCTAssertNotEqual(ten.value, "Value: 10")
        XCTAssertEqual(calledCount, 1)
    }

}
