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
    public import ISO_9945_Kernel_Thread
    public import Linux_Kernel_System_Standard
    public import Error_Primitives
    public import System_Primitives

    extension Linux.Thread {
        /// Thread affinity namespace.
        public enum Affinity {}
    }

    extension Linux.Thread.Affinity {
        /// Applies affinity to the current thread via `sched_setaffinity(2)`.
        ///
        /// ## Implementation
        /// - `.any`: No-op, returns immediately
        /// - `.cores(set)`: Delegates to the re-anchored
        ///   ``Linux/Kernel/Thread/Affinity/setMask(tid:cores:)`` (swift-linux-standard),
        ///   the post-hoist home of this mechanism (swift-iso/swift-iso-9945#64)
        /// - `.numaNode(id)`: Resolves node to CPUs via `System.Topology.NUMA.discover`,
        ///   then delegates to the same re-anchored mechanism
        ///
        /// ## Errors
        /// - `.platform(code)`: sched_setaffinity failed (POSIX errno)
        /// - `.invalidNode(id)`: NUMA node not found in topology
        ///
        /// - Parameter affinity: The affinity specification.
        /// - Throws: `ISO_9945.Kernel.Thread.Affinity.Error` on failure.
        public static func apply(_ affinity: ISO_9945.Kernel.Thread.Affinity) throws(ISO_9945.Kernel.Thread.Affinity.Error) {
            switch affinity.kind {
            case .any:
                // No constraint - nothing to do
                return

            case .cores(let cores):
                do {
                    try Linux.Kernel.Thread.Affinity.setMask(cores: cores)
                } catch {
                    switch error {
                    case .platform(let code):
                        throw .platform(code)
                    }
                }

            case .numaNode(let nodeID):
                let numaState = System.Topology.NUMA.discover()
                guard case .nonUniform(let nodes) = numaState,
                    let node = nodes.first(where: { $0.id == nodeID })
                else {
                    throw .invalidNode(nodeID)
                }
                do {
                    try Linux.Kernel.Thread.Affinity.setMask(cores: node.cpus)
                } catch {
                    switch error {
                    case .platform(let code):
                        throw .platform(code)
                    }
                }
            }
        }
    }
#endif
