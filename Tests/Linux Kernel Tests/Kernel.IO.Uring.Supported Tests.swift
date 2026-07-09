// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-linux open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-linux project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Linux_Kernel_IO_Uring
import Testing

// io_uring types are entirely behind #if os(Linux) at L2.
// These tests can only compile and run on Linux.

#if os(Linux)

    extension Kernel.IO.Uring {
        @Suite
        struct Test {
            @Suite struct Unit {}
        }
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Test.Unit {
        @Test func `isSupported returns a Bool`() {
            let result: Bool = Kernel.IO.Uring.isSupported
            // We cannot assert the value since it depends on the kernel,
            // but the property must be accessible and return a Bool.
            _ = result
        }

        @Test func `isSupported is stable across calls`() {
            let first = Kernel.IO.Uring.isSupported
            let second = Kernel.IO.Uring.isSupported
            #expect(first == second)
        }
    }

#endif
