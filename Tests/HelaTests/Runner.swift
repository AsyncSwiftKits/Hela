import Foundation

struct Runner {
    enum Behavior {
        case ok
        case fatalError
        case dispatchPreconditionOnMain
        case dispatchPreconditionOffMain
        case precondition
        case preconditionFailure
    }

    func run(behavior: Behavior = .dispatchPreconditionOnMain) {
        switch behavior {
        case .ok:
            print("Running")
        case .fatalError:
            fatalError("Always fatal")
        case .dispatchPreconditionOnMain:
            dispatchPrecondition(condition: .onQueue(.main))
        case .dispatchPreconditionOffMain:
            dispatchPrecondition(condition: .notOnQueue(.main))
        case .precondition:
            precondition(false, "Always false")
        case .preconditionFailure:
            preconditionFailure("Always fail")
        }
    }
}
