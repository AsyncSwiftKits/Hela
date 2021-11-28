import XCTest
@testable import Hela

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

}
