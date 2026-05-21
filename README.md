# SwiftObjCAdvancedPractice

SwiftObjCAdvancedPractice is a practice repository for exploring modern Swift, Objective-C runtime features, and a small Vapor-based server in a single package.

The codebase is intentionally split by responsibility so each target stays focused:

- Core Swift language examples live in a reusable library target.
- Objective-C runtime helpers live in their own mixed-language target.
- The command-line tool runs the demonstrations from the library.
- The Vapor server exposes a lightweight HTTP entry point for the same sample domain.
- The SwiftUI sample is kept in `Examples/` so it is clearly separated from the package targets.

## Project Layout

```text
SwiftObjCAdvancedPractice/
├── Package.swift
├── README.md
├── Examples/
│   └── SwiftUI/
│       └── SwiftUIViews.swift
├── Sources/
│   ├── RuntimeHelperObjC/
│   │   ├── RuntimeHelper.m
│   │   └── include/
│   │       └── RuntimeHelper.h
│   ├── SwiftObjCAdvancedPractice/
│   │   ├── AdvancedPatterns.swift
│   │   ├── Bridge.swift
│   │   ├── ConcurrentDataManager.swift
│   │   ├── Example.swift
│   │   └── MemoryManagement.swift
│   ├── SwiftObjCAdvancedPracticeCLI/
│   │   └── main.swift
│   └── SwiftObjCAdvancedPracticeServer/
│       └── main.swift
└── Tests/
    └── SwiftObjCAdvancedPracticeTests/
        ├── ConcurrencyTests.swift
        ├── PropertyWrapperTests.swift
        └── SwiftObjCAdvancedPracticeTests.swift
```

## What The Package Demonstrates

### Core Swift

- Actors and structured concurrency
- `async`/`await` and task groups
- Protocols with associated types
- Result builders
- Property wrappers
- Generic constraints
- Memory management patterns

### Objective-C Runtime

- Method swizzling
- Dynamic class creation
- KVO-style observation
- Message forwarding
- Blocks and GCD

### Swift and Objective-C Interoperability

- Bridging Objective-C helpers into Swift
- Inspecting Objective-C runtime metadata from Swift
- Calling runtime demonstrations through a Swift-facing API

### Vapor Server

- Minimal HTTP server bootstrap
- Health check route
- Example metadata route

## Requirements

- macOS 13 or later
- Xcode 15 or later
- Swift 5.9 or later

## Build

```bash
swift build
```

## Test

```bash
swift test
```

## CLI Usage

Run all demonstrations:

```bash
swift run SwiftObjCAdvancedPracticeCLI --all
```

Run a specific section:

```bash
swift run SwiftObjCAdvancedPracticeCLI --concurrency
swift run SwiftObjCAdvancedPracticeCLI --patterns
swift run SwiftObjCAdvancedPracticeCLI --memory
swift run SwiftObjCAdvancedPracticeCLI --bridge
```

## Vapor Server

Start the server target:

```bash
swift run SwiftObjCAdvancedPracticeServer
```

Available routes:

- `GET /health`
- `GET /examples`

## SwiftUI Example

The SwiftUI sample is stored under `Examples/SwiftUI/` instead of `Sources/` because it is a reference app, not a package target. This keeps the package manifest focused on the library, CLI, and server targets.

## Key Files

- [`Package.swift`](./Package.swift) defines the library, CLI, server, and Objective-C runtime targets.
- [`Sources/SwiftObjCAdvancedPractice/Example.swift`](./Sources/SwiftObjCAdvancedPractice/Example.swift) contains the runnable demonstrations.
- [`Sources/SwiftObjCAdvancedPractice/Bridge.swift`](./Sources/SwiftObjCAdvancedPractice/Bridge.swift) exposes Objective-C runtime helpers to Swift.
- [`Sources/SwiftObjCAdvancedPracticeServer/main.swift`](./Sources/SwiftObjCAdvancedPracticeServer/main.swift) bootstraps Vapor.
- [`Sources/RuntimeHelperObjC/RuntimeHelper.m`](./Sources/RuntimeHelperObjC/RuntimeHelper.m) implements the Objective-C runtime demo behavior.

## Notes

- The Vapor dependency is now wired into an executable target, so it is no longer just a declared dependency.
- The SwiftUI example is intentionally outside the package targets to avoid mixing application code with the library module.
- The Objective-C runtime examples are powerful but low-level; they should be used carefully outside of a learning context.

## License

Educational sample project.
