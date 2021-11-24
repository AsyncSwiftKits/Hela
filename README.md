# Hela

Assertions for XCTest which prevent fatal errors causing the process to die.

The following assertions are supported. These functions are built on top of [CwlPreconditionTesting] which was created by Matt Gallagher of [Cocoa with Love]. That package allows for intercepting the signal from fatal errors to prevent the process from dying.

* `XCTAssertThrowFatalError`
* `XCTAssertNoThrowFatalError`

## Why

Often we want to use preconditions to indicate that a code path should never be reached. In Swift the [Never] type formalizes this behavior with compiler support. Any function which returns `Never` will not return as the process should be terminated. This can be done by calling `fatalError()` which is common when unwrapping `self` which was made _weak_ with a capture list in a closure. With the code below, the _else_ block does not have to return because `Never` is the return value of `fatalError()` which satisfies the compiler.

```swift
guard let self = self else { fatalError() }
```

We also can make use of `precondition` and `preconditionFailure` to indicate when execution has reached an unrecoverable state which should not be possible. For Dispatch, we can use `dispatchPrecondition` to confirm execution is either on a specific queue or not and raise a runtime exception if it is not which results in useful logs which point directly to that line of code to more quickly understand the root cause.

By using these test assertions it is possible to create tests which ensure these fatal errors are being raised as intended.

## Usage

This package includes tests which show how these functions can be used. Note that the underlying package supports iOS and macOS only currently. For tests which are running on tvOS and watchOS an `XCTSkip` error will be thrown to indicate that the test was skipped so that it does not simply fail.

## Name

Why Hela? [Hela] is a Marvel character who is a necromancer who can raise the dead. Once a fatal error is raised normally a process will die. With help from Hela, the process can be raised from the dead and continue running your tests.

---
[CwlPreconditionTesting]: https://github.com/mattgallagher/CwlPreconditionTesting
[Cocoa with Love]: https://www.cocoawithlove.com
[Never]: https://developer.apple.com/documentation/swift/never
[Hela]: https://en.wikipedia.org/wiki/Hela_(character)
