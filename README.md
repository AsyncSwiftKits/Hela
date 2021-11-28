# Hela

Assertions for XCTest which prevent fatal errors causing the process to die.

The following assertions are supported. These functions are built on top of [CwlPreconditionTesting] which was created by Matt Gallagher of [Cocoa with Love]. That package allows for intercepting the signal from fatal errors to prevent the process from dying.

* `XCTAssertThrowFatalError`
* `XCTAssertNoThrowFatalError`

## Usage

This package includes tests which show how these functions can be used. Note that the underlying package supports iOS and macOS only currently. For tests which are running on tvOS and watchOS an `XCTSkip` error will be thrown to indicate that the test was skipped so that it does not simply fail. These functions take a closure is run. The first one expects second one does not. If an fatal exception is raised the first assert function will pass and if not the second assert function will pass. These assert functions mirror the non-fatal error assert functions included with XCTest.

## Build Failures with XCTest

When Swift packages are added to an Xcode project it is usually linked by the primary target which is normally the intended build behavior. But the normal build target is not a test target and should not be linking Hela and won't be linking XCTest. Removing Hela as a linked target will also remove the Swift package from the project, so first add Hela to your test target as a target dependency and also link it. Then remove it from the primary target as a linked dependency. Then your build should work.

## Why

Type safety can provide a lot of protection with support from the compiler making many bugs or invalid conditions to be impossible. Preconditions allow developers to impose strict requirements at runtime to compliment type safety. Apple prefers to have apps to be killed when it the problem is a result of programmer error. Placing preconditions in code to verify assumptions and enforce requirements can help developers understand why their code is not running properly long before it reaches production. Below is example of code which must run on the main thread and will sync to it with the requirement that it not already on the main thread. It may be necessary to do this work on the main thread before leaving the current code block and documentation would note that running this code should be off the main thread.

```swift
precondition(Thread.isMainThread, "Must not run on main thread")

DispatchQueue.main.sync {
    // run code on main thread
}
```

This precondition can also be handled by a special function from the Dispatch framework. One advantage of `dispatchPrecondition` is that you can also check if execution is on or off one of your own queues. The code below requires that execution is not running on the `.main` queue while it is running on the `serialQueue`.

```swift
dispatchPrecondition(condition: .notOnQueue(.main))
dispatchPrecondition(condition: .onQueue(serialQueue))
```

Both will not allow execution to continue if it is already operating on the main thread. If an app somehow manages to run this code on the main thread it will result in a runtime exception, crash the app and generate a crash report. That crash report will point directly to this line and show the code which lead up to the crash which is very helpful in diagnosing the crash. If the app continues running and crashes later it may be misleading and require more time to diagnose the problem.

Another common scenario is unwrapping `self` which was made _weak_ with a capture list in an escaping closure. It is necessary to use _self_ when referencing anything outside the scope of the closure and using _weak self_ will break the potential retain cycle. Instead of risking the retain cycle many developers will do the weak self dance and immediate unwrap with a guard statement which requires returning from the _else_ statement.

```swift
guard let self = self else { fatalError() }
```

Fortunately `fatalError` returns [Never] which means it will never return. It is a special type supported by the compiler which formalizes this scenario. Any function which returns `Never` will not return as the process should be terminated. It possible to use `preconditionFailure` in the same as it also returns `Never`. Both `precondition` and `dispatchPrecondition` do not return `Never` as they behave conditionally.

## Assertions versus Preconditions

A key difference between an assert and precondition is that asserts are suppressed in release builds. Placing many asserts in your normal runtime code supports the development process by halting execution if any assertion fails to let a developer immediately see where the code has reached a bad state. Instead of setting breakpoints these assertions can stay in the code for ongoing development while being stripped out for release builds. A precondition can check an absolute requirement such as configuration which is necessary for the app to operate properly when that configuration should be included in the app bundle. It could also require that the Documents or Caches directory exists which it should unless something has seriously gone wrong. Triggering a crash and collecting crash reports will help with being aware of such problems in release builds. Ideally you will catch these problems with early testing before the app is available to users.

For test automation, asserts are a part of the Arrange, Act and Assert cycle.

## Name

Why Hela? [Hela] is a Marvel character who is a necromancer who can raise the dead. Once a fatal error is raised normally a process will die. With help from Hela, the process can be raised from the dead and continue running your tests.

---
[CwlPreconditionTesting]: https://github.com/mattgallagher/CwlPreconditionTesting
[Cocoa with Love]: https://www.cocoawithlove.com
[Never]: https://developer.apple.com/documentation/swift/never
[Hela]: https://en.wikipedia.org/wiki/Hela_(character)
