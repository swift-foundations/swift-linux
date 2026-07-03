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

#if os(Linux)
    extension Linux.Thread.Affinity {
        @Suite
        struct Test {
            @Suite struct Unit {}
            @Suite struct EdgeCase {}
        }
    }

    // MARK: - Unit Tests

    extension Linux.Thread.Affinity.Test.Unit {
        @Test func `Affinity any has kind any`() {
            let affinity = Kernel.Thread.Affinity.any
            #expect(affinity.kind == .any)
        }

        @Test func `Affinity cores creates cores kind with correct set`() {
            let affinity = Kernel.Thread.Affinity.cores([0, 1, 2, 3])
            if case .cores(let cores) = affinity.kind {
                #expect(cores == Set([0, 1, 2, 3]))
            } else {
                Issue.record("Expected .cores kind")
            }
        }

        @Test func `Affinity numaNode creates numaNode kind with correct id`() {
            let affinity = Kernel.Thread.Affinity.numaNode(0)
            if case .numaNode(let id) = affinity.kind {
                #expect(id == 0)
            } else {
                Issue.record("Expected .numaNode kind")
            }
        }

        @Test func `Affinity is Equatable`() {
            let a = Kernel.Thread.Affinity.any
            let b = Kernel.Thread.Affinity.any
            let c = Kernel.Thread.Affinity.cores([0])
            #expect(a == b)
            #expect(a != c)
        }

        @Test func `Affinity is Sendable`() {
            let affinity: any Sendable = Kernel.Thread.Affinity.any
            #expect(affinity is Kernel.Thread.Affinity)
        }
    }

    // MARK: - Apply Tests (platform-gated)

    extension Linux.Thread.Affinity.Test.Unit {
        @Test func `apply any is a no-op and succeeds`() {
            // .any is a no-op, should always succeed
            #expect(throws: Never.self) {
                try Linux.Thread.Affinity.apply(.any)
            }
        }
    }

    // MARK: - Error Tests

    extension Linux.Thread.Affinity.Test.Unit {
        @Test func `Error unsupported exists`() {
            let error = Kernel.Thread.Affinity.Error.unsupported
            #expect(error == .unsupported)
        }

        @Test func `Error invalidNode carries node id`() {
            let error = Kernel.Thread.Affinity.Error.invalidNode(42)
            if case .invalidNode(let id) = error {
                #expect(id == 42)
            } else {
                Issue.record("Expected .invalidNode case")
            }
        }

        @Test func `Error tooManyCPUs exists`() {
            let error = Kernel.Thread.Affinity.Error.tooManyCPUs
            #expect(error == .tooManyCPUs)
        }

        @Test func `Error platform carries error code`() {
            let code = Error_Primitives.Error.Code.posix(22)
            let error = Kernel.Thread.Affinity.Error.platform(code)
            if case .platform(let c) = error {
                #expect(c == code)
            } else {
                Issue.record("Expected .platform case")
            }
        }

        @Test func `Error conforms to Swift Error`() {
            let error: any Swift.Error = Kernel.Thread.Affinity.Error.unsupported
            #expect(error is Kernel.Thread.Affinity.Error)
        }

        @Test func `Error is Sendable`() {
            let error: any Sendable = Kernel.Thread.Affinity.Error.unsupported
            #expect(error is Kernel.Thread.Affinity.Error)
        }

        @Test func `Error is Equatable`() {
            let a = Kernel.Thread.Affinity.Error.unsupported
            let b = Kernel.Thread.Affinity.Error.unsupported
            let c = Kernel.Thread.Affinity.Error.tooManyCPUs
            #expect(a == b)
            #expect(a != c)
        }

        @Test func `Error is Hashable`() {
            var set = Set<Kernel.Thread.Affinity.Error>()
            set.insert(.unsupported)
            set.insert(.invalidNode(1))
            set.insert(.tooManyCPUs)
            set.insert(.unsupported)  // duplicate
            #expect(set.count == 3)
        }

        @Test func `Error descriptions are non-empty`() {
            let cases: [Kernel.Thread.Affinity.Error] = [
                .unsupported,
                .invalidNode(7),
                .tooManyCPUs,
                .platform(.posix(1)),
            ]
            for error in cases {
                #expect(!error.description.isEmpty)
            }
        }
    }

    // MARK: - Edge Cases

    extension Linux.Thread.Affinity.Test.EdgeCase {
        @Test func `cores with empty set creates cores kind`() {
            let affinity = Kernel.Thread.Affinity.cores([])
            if case .cores(let cores) = affinity.kind {
                #expect(cores.isEmpty)
            } else {
                Issue.record("Expected .cores kind")
            }
        }

        @Test func `cores deduplicates input sequence`() {
            let affinity = Kernel.Thread.Affinity.cores([0, 0, 1, 1, 2])
            if case .cores(let cores) = affinity.kind {
                #expect(cores.count == 3)
                #expect(cores == Set([0, 1, 2]))
            } else {
                Issue.record("Expected .cores kind")
            }
        }

        @Test func `all Kind cases are distinct`() {
            let cases: [Kernel.Thread.Affinity.Kind] = [
                .any,
                .cores(Set([0])),
                .numaNode(0),
            ]
            for i in 0..<cases.count {
                for j in (i + 1)..<cases.count {
                    #expect(cases[i] != cases[j])
                }
            }
        }

        @Test func `all Error cases are distinct`() {
            let code = Error_Primitives.Error.Code.posix(1)
            let cases: [Kernel.Thread.Affinity.Error] = [
                .unsupported,
                .invalidNode(0),
                .tooManyCPUs,
                .platform(code),
            ]
            for i in 0..<cases.count {
                for j in (i + 1)..<cases.count {
                    #expect(cases[i] != cases[j])
                }
            }
        }

        @Test func `invalidNode with different ids are distinct`() {
            let a = Kernel.Thread.Affinity.Error.invalidNode(0)
            let b = Kernel.Thread.Affinity.Error.invalidNode(1)
            #expect(a != b)
        }
    }

    // MARK: - Support Level Tests

    extension Linux.Thread.Affinity.Test.Unit {
        @Test func `Support none exists`() {
            let support = Kernel.Thread.Affinity.Support.none
            #expect(support == .none)
        }

        @Test func `Support advisory exists`() {
            let support = Kernel.Thread.Affinity.Support.advisory
            #expect(support == .advisory)
        }

        @Test func `Support enforced exists`() {
            let support = Kernel.Thread.Affinity.Support.enforced
            #expect(support == .enforced)
        }

        @Test func `Support cases are all distinct`() {
            #expect(Kernel.Thread.Affinity.Support.none != .advisory)
            #expect(Kernel.Thread.Affinity.Support.advisory != .enforced)
            #expect(Kernel.Thread.Affinity.Support.enforced != .none)
        }

        @Test func `Support is Sendable`() {
            let support: any Sendable = Kernel.Thread.Affinity.Support.enforced
            #expect(support is Kernel.Thread.Affinity.Support)
        }
    }

    // MARK: - Failure Policy Tests

    extension Linux.Thread.Affinity.Test.Unit {
        @Test func `Failure ignore exists`() {
            let failure = Kernel.Thread.Affinity.Failure.ignore
            #expect(failure == .ignore)
        }

        @Test func `Failure report exists`() {
            let failure = Kernel.Thread.Affinity.Failure.report
            #expect(failure == .report)
        }

        @Test func `Failure fatal exists`() {
            let failure = Kernel.Thread.Affinity.Failure.fatal
            #expect(failure == .fatal)
        }

        @Test func `Failure cases are all distinct`() {
            let cases: [Kernel.Thread.Affinity.Failure] = [
                .ignore, .report, .fatal,
            ]
            for i in 0..<cases.count {
                for j in (i + 1)..<cases.count {
                    #expect(cases[i] != cases[j])
                }
            }
        }
    }
#endif
