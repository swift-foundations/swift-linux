# Linux

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-compositions/swift-linux/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-compositions/swift-linux/actions/workflows/ci.yml)

Type-safe wrappers for Linux-specific kernel mechanisms. Provides epoll event notification and io_uring async I/O with typed throws and full Sendable compliance.

---

## Key Features

- **epoll support** – Scalable I/O event notification via `epoll_create1`, `epoll_ctl`, `epoll_wait`
- **io_uring support** – High-performance async I/O (Linux kernel 5.1+) with submission/completion queues
- **Runtime detection** – `isSupported` check for io_uring availability with environment variable override
- **Typed throws end-to-end** – Every error type is statically known; no `any Error` escapes the API surface
- **Swift 6 strict concurrency** – Full `Sendable` compliance with documented thread-safety guarantees
- **Policy-free design** – Raw syscall wrappers without opinions on scheduling, buffering, or lifecycle

---

## Installation

### Package.swift dependency

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-linux.git", from: "0.1.0")
]
```

### Target dependency

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Linux Kernel", package: "swift-linux")
    ]
)
```

### Requirements

- Swift 6.2+
- Linux (glibc or musl)
- Kernel 5.1+ for io_uring support

---

## Quick Start

```swift
import Linux_Kernel

// Check io_uring availability
if Kernel.IO.Uring.isSupported {
    // Create an io_uring instance
    var params = Kernel.IO.Uring.Params()
    let ringFd = try Kernel.IO.Uring.setup(entries: 256, params: &params)
    defer { Kernel.IO.Uring.close(ringFd) }

    print("io_uring ready: \(params.sqEntries) SQ entries, \(params.cqEntries) CQ entries")
} else {
    // Fall back to epoll
    let epfd = try Kernel.Event.Poll.create()
    defer { try? Kernel.Close.close(epfd) }

    print("Using epoll fallback")
}
```

---

## Architecture

| Type | Description |
|------|-------------|
| `Linux` | Linux platform namespace |
| `Kernel.Event.Poll` | epoll syscall wrappers (`create`, `ctl`, `wait`) |
| `Kernel.Event.Poll.Event` | Event structure with event mask and user data |
| `Kernel.Event.Poll.Error` | Typed errors for epoll operations |
| `Kernel.IO.Uring` | io_uring syscall wrappers (`setup`, `enter`, `register`, `close`) |
| `Kernel.IO.Uring.Params` | Setup parameters and kernel-returned ring configuration |
| `Kernel.IO.Uring.Submission.Queue.Entry` | SQE wrapper for describing I/O operations |
| `Kernel.IO.Uring.Completion.Queue.Entry` | CQE wrapper for operation results |
| `Kernel.IO.Uring.Opcode` | Operation codes for io_uring submissions |
| `Kernel.IO.Uring.Error` | Typed errors for io_uring operations |

---

## Platform Support

| Platform         | CI  | Status        |
|------------------|-----|---------------|
| Linux            | ✅  | Full support  |
| macOS            | —   | Not supported |
| iOS/tvOS/watchOS | —   | Not supported |
| Windows          | —   | Not supported |

This package provides Linux-specific kernel mechanisms. For cross-platform kernel primitives, see [swift-kernel-primitives](https://github.com/coenttb/swift-kernel-primitives).

---

## Related Packages

### Dependencies

- [swift-kernel-primitives](https://github.com/coenttb/swift-kernel-primitives): Cross-platform kernel syscall wrappers
- [swift-posix](https://github.com/swift-compositions/swift-posix): POSIX kernel bindings
- [swift-standards](https://github.com/swift-standards/swift-standards): Binary data types and standards

### Used By

- [swift-io](https://github.com/coenttb/swift-io): Async I/O executor built on kernel primitives

---

## License

This project is licensed under the Apache License v2.0. See [LICENSE.md](LICENSE.md) for details.
