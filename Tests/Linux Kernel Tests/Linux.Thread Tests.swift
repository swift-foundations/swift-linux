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

import Linux_Kernel_Thread
import Testing

extension Linux.Thread {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

// MARK: - Unit Tests

extension Linux.Thread.Test.Unit {
    @Test func `namespace exists`() {
        // Linux.Thread is declared as a public enum — verify it is reachable.
        _ = Linux.Thread.self
    }
}
