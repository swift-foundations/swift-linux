// Linux.Random.swift
// Cryptographically-secure random number generation for Linux.

#if os(Linux)

    // MARK: - Typealias

    extension Linux {
        /// Typealias to Random namespace.
        ///
        /// Allows `Linux.Random.fill()` syntax while sharing the same
        /// underlying type across all platforms.
        public typealias Random = Random_Primitives.Random
    }

    // MARK: - Platform Implementation

    extension Random {
        /// Fills the buffer with cryptographically-secure random bytes.
        ///
        /// Delegates to ``Linux/Kernel/Random/getrandom(_:)-(UnsafeMutableRawBufferPointer)``
        /// which wraps `getrandom(2)` — handles partial reads and EINTR
        /// automatically, and surfaces `entropyNotReady` when the entropy pool
        /// is not yet initialized.
        ///
        /// - Parameter buffer: The buffer to fill with random bytes.
        ///   If the buffer is empty, this method returns immediately.
        /// - Throws: `Error.entropyNotReady` if the entropy pool is not ready,
        ///   or `Error.systemError` for other failures.
        ///
        /// ## Example
        ///
        /// ```swift
        /// var bytes = [UInt8](repeating: 0, count: 32)
        /// try bytes.withUnsafeMutableBytes { buffer in
        ///     try Random.fill(buffer)
        /// }
        /// ```
        public static func fill(
            _ buffer: UnsafeMutableRawBufferPointer
        ) throws(Error) {
            try unsafe Linux.Kernel.Random.getrandom(buffer)
        }
    }

#endif
