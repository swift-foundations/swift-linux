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
    public import ISO_9945_Kernel_File

    // MARK: - Linux-specific File.Flush policy
    //
    // Per [PLAT-ARCH-008k] Spec/Policy Namespace Split (Wave 3, 2026-04-30):
    // `Linux.Kernel` and `Darwin.Kernel` are now distinct nominal types; this
    // extension targets `ISO_9945.Kernel.File.Flush` directly (the spec-shared
    // home) so swift-kernel can compose the cross-platform name without
    // redeclaration. On Linux, `ISO_9945.Kernel.File.Flush.data(_:)` IS the
    // canonical entry point — there is no companion at L3 swift-kernel; the
    // platform packages (swift-darwin, swift-linux) extend the shared namespace
    // directly per [PLAT-ARCH-008d]. `fdatasync(2)` is POSIX-specified but Darwin
    // does not implement it, so the "data-only durability" policy is platform-
    // specific even though the syscall name is POSIX. swift-posix (shared L3)
    // hosts only syscalls implemented on both Darwin and Linux.

    extension ISO_9945.Kernel.File.Flush {
        /// Synchronizes a file's data (without metadata) to storage device,
        /// automatically retrying on EINTR.
        ///
        /// Delegates to ``ISO_9945/Kernel/File/Flush/fdatasync(_:)`` — `fdatasync(2)`
        /// is POSIX-specified but Darwin does not implement it, so the policy
        /// wrapper lives in the Linux-specific package.
        ///
        /// Pairs with the Darwin companion in swift-darwin so consumers write
        /// `ISO_9945.Kernel.File.Flush.data(fd)` and get the right semantic on every
        /// POSIX platform.
        ///
        /// - Parameter descriptor: The file descriptor.
        /// - Throws: ``Kernel/File/Flush/Error`` on failure (excluding EINTR).
        @inlinable
        public static func data(_ descriptor: borrowing ISO_9945.Kernel.Descriptor) throws(Self.Error) {
            while true {
                do {
                    try Self.fdatasync(descriptor)
                    return
                } catch  where error.code.isInterrupted {
                    continue  // Retry on EINTR
                }
            }
        }
    }

#endif
