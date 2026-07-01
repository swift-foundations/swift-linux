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

#if os(Linux) || os(Android) || os(OpenBSD)

public import ISO_9945_Core
public import ISO_9945_Kernel_Thread

// MARK: - POSIX.Kernel.Thread.ID bridge (Wave 3.5-Final-Atomic Class B Completion)
//
// 2026-05-02 — Class B bridge typealias for `Kernel.Thread.ID` on Linux.
//
// Discovered during Item 5 Phase 4 downstream verification cascade
// (swift-io test-support consumed `Kernel.Thread.ID` post-flip and
// surfaced the gap). Initial Class A attempt at swift-posix failed to
// compile because `ISO_9945.Kernel.Thread.ID` is declared at L2
// platform-specific `Linux_Kernel_System_Standard` (pid_t struct) —
// swift-posix L3-policy has no visibility into platform-specific L2
// modules per [PLAT-ARCH-008e].
//
// Architectural placement: this bridge belongs at swift-linux L3-policy,
// where the Linux-specific L2 module (`Linux_Kernel_System_Standard`,
// transitively re-exported via `Linux_Kernel_System`) is already imported.
// Same precedent as Wave 3.5-Final-Atomic IO.Uring bridge at swift-linux L3
// + Kqueue bridge at swift-darwin L3 — Linux-specific bridging is the
// platform L3-policy's responsibility, not swift-posix L3-policy's.
//
// On Linux, `ISO_9945.Kernel.Thread.ID` resolves to the pid_t struct
// declared at `Linux_Kernel_System_Standard/Linux.Kernel.Thread.ID.swift:34`.
// Darwin platforms get the Mach-port-name struct from
// `Darwin_Kernel_Standard` via the symmetric bridge at swift-darwin L3.

extension POSIX.Kernel.Thread {
    /// Thread identifier (Hashable, Sendable, RawRepresentable,
    /// CustomStringConvertible) — typealias to canonical Linux-specific
    /// L2 declaration (pid_t).
    public typealias ID = ISO_9945.Kernel.Thread.ID
}

#endif
