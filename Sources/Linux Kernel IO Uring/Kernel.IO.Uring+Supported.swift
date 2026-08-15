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

#if os(Linux)

    public import ISO_9945_Core
    public import ISO_9945_Kernel_Environment
    import POSIX_Kernel

    // MARK: - Runtime Detection

    extension ISO_9945.Kernel.IO.Uring {
        /// Whether io_uring is available on this system.
        ///
        /// Checks by attempting `io_uring_setup` with minimal parameters.
        /// Result is cached after first call.
        ///
        /// Can be disabled via the `IO_URING_DISABLED=1` environment variable.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// if ISO_9945.Kernel.IO.Uring.isSupported {
        ///     // Use io_uring backend
        /// } else {
        ///     // Fall back to epoll or other backend
        /// }
        /// ```
        public static var isSupported: Bool {
            _isSupported
        }

        /// Cached support check.
        private static let _isSupported: Bool = {
            let disabled = unsafe ISO_9945.Kernel.Environment.withValueBytes("IO_URING_DISABLED") {
                span in
                span.count == 1 && span[0] == UInt8(ascii: "1")
            }
            if disabled == true { return false }

            var params = Params()
            do throws(Self.Error) {
                let fd = try setup(entries: .one, params: &params)
                close(fd)
                return true
            } catch {
                return false
            }
        }()
    }

#endif
