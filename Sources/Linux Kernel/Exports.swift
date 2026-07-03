@_exported public import Linux_Kernel_Descriptor
@_exported public import Linux_Kernel_Event
@_exported public import Linux_Kernel_File
@_exported public import Linux_Kernel_Futex
@_exported public import Linux_Kernel_IO
@_exported public import Linux_Kernel_IO_Uring
@_exported public import Linux_Kernel_Memory
@_exported public import Linux_Kernel_Pipe
@_exported public import Linux_Kernel_Random
@_exported public import Linux_Kernel_Socket
@_exported public import Linux_Kernel_System
@_exported public import Linux_Kernel_Thread
// Wave 3.5-Final-Atomic (2026-05-02): consolidate to umbrella POSIX_Kernel import
// (covers POSIX root namespace + all POSIX.Kernel.X sub-namespaces post-flip).
@_exported public import POSIX_Kernel

/// Cross-platform `Kernel` namespace at L3.
///
/// Wave 3.5-Final-Atomic (2026-05-02): flipped from `ISO_9945.Kernel` to
/// `POSIX.Kernel`. Per Wave 3.5 envelope (Item 4 of post-Path-X cycles),
/// POSIX-shared content is now wrapped at the `POSIX.Kernel.X` namespace
/// with method-wrappers + value-type typealiases delegating to iso-9945
/// typed Phase 1.5 forms. The L3-unifier `Kernel` typealias targets
/// POSIX.Kernel; typealias transitivity resolves the chain to iso-9945
/// at compile time, preserving L3-policy → L2 → L1 composition discipline
/// per [PLAT-ARCH-008e].
public typealias Kernel = POSIX.Kernel

/// Re-export Linux namespace (flows through L2 domain targets via Linux Standard Core).
public typealias Linux = Linux_Kernel_System_Standard.Linux

// MARK: - IO.Uring bridge (Wave 3.5-Final-Atomic Q1 disposition)
//
// Linux's IO.Uring struct lives at L2 swift-linux-standard
// (`Linux Kernel IO Uring Standard/Linux.Kernel.IO.Uring.swift:64`) and
// extends `ISO_9945.Kernel.IO` inside `#if os(Linux)`. Pre-flip,
// `Kernel.IO.Uring` resolved via `Kernel = ISO_9945.Kernel` directly.
// Post-flip (`Kernel = POSIX.Kernel`), `Kernel.IO.Uring` would resolve
// to `POSIX.Kernel.IO.Uring` — but POSIX.Kernel.IO has no Uring extension
// (Linux-specific; not part of POSIX-shared surface).
//
// This typealias bridges the namespace gap. Placement at swift-linux L3
// (rather than swift-kernel L3-unifier) preserves [PLAT-ARCH-008e]
// composition discipline: Linux-specific bridging is Linux's L3-policy
// responsibility, not the cross-platform L3-unifier's.
//
// The `#if os(Linux)` guard mirrors the source declaration's guard;
// on macOS the underlying `ISO_9945.Kernel.IO.Uring` extension does
// not exist and the typealias would fail to resolve.
#if os(Linux)

    public import ISO_9945_Core
    extension POSIX.Kernel.IO {
        public typealias Uring = ISO_9945.Kernel.IO.Uring
    }
#endif
