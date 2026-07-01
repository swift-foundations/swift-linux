// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-linux open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-linux project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if os(Linux)

public import ISO_9945_Core
@_spi(Syscall) public import Linux_Kernel_IO_Uring_Standard

// MARK: - L3-policy Kernel-namespace compatibility wrappers

extension ISO_9945.Kernel.IO.Uring.Target {
    /// Creates a descriptor target by borrowing a kernel descriptor.
    ///
    /// The target borrows the descriptor's lifetime — it cannot outlive
    /// the descriptor. The raw fd number is extracted at construction and
    /// is safe to use for the SQE because the descriptor stays open.
    @_lifetime(borrow fd)
    public init(descriptor fd: borrowing ISO_9945.Kernel.Descriptor) {
        self = .descriptor(fd._rawValue)
    }
}

#endif
