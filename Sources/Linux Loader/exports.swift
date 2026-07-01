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

// Scope — Linux + FreeBSD + OpenBSD + Android.
//
// The loader compiles on all four because symbol lookup goes through
// POSIX `dlopen` / `dlsym` and the ELF section-enumeration path in the
// underlying L2 `Linux_Loader_Standard` is uniform across them. This
// guard mirrors the L2 target's own scope (see `Linux.Loader*.swift`
// in swift-linux-standard).
//
// Other swift-linux targets (Kernel Random, Thread Affinity, File Flush,
// IO Uring) stay strictly `#if os(Linux)` because they wrap
// Linux-specific syscalls (`getrandom(2)`, `sched_setaffinity(2)`,
// `fdatasync(2)`, `io_uring_*`) with no BSD analogue.
#if os(Linux) || os(FreeBSD) || os(OpenBSD) || os(Android)
@_exported public import Linux_Loader_Standard
#endif
