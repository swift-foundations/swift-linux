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

import Linux_Kernel_Random
import Testing

extension Random {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

// MARK: - Random.Error Tests (available on all platforms)

extension Random.Test.Unit {
    @Test func `entropyNotReady error exists`() {
        let error = Random.Error.entropyNotReady
        #expect(error == .entropyNotReady)
    }

    @Test func `systemError carries errno value`() {
        let error = Random.Error.systemError(22)
        if case .systemError(let code) = error {
            #expect(code == 22)
        } else {
            Issue.record("Expected .systemError case")
        }
    }

    @Test func `Error conforms to Swift Error`() {
        let error: any Swift.Error = Random.Error.entropyNotReady
        #expect(error is Random.Error)
    }

    @Test func `Error is Sendable`() {
        let error: any Sendable = Random.Error.entropyNotReady
        #expect(error is Random.Error)
    }

    @Test func `Error is Hashable`() {
        var set = Set<Random.Error>()
        set.insert(.entropyNotReady)
        set.insert(.systemError(1))
        set.insert(.systemError(2))
        set.insert(.entropyNotReady)  // duplicate
        #expect(set.count == 3)
    }

    @Test func `Error cases are distinct`() {
        let a = Random.Error.entropyNotReady
        let b = Random.Error.systemError(1)
        #expect(a != b)
    }
}

// MARK: - Edge Cases

extension Random.Test.`Edge Case` {
    @Test func `systemError with different codes are distinct`() {
        let a = Random.Error.systemError(1)
        let b = Random.Error.systemError(2)
        #expect(a != b)
    }

    @Test func `systemError with same code are equal`() {
        let a = Random.Error.systemError(42)
        let b = Random.Error.systemError(42)
        #expect(a == b)
    }
}

// MARK: - Linux.Random typealias test

#if os(Linux)

    extension Random.Test.Unit {
        @Test func `Linux Random typealias resolves to Random`() {
            #expect(Linux.Random.self == Random.self)
        }
    }

#endif

// MARK: - Linux-only: Random.fill tests

#if os(Linux)

    extension Random.Test.Unit {
        @Test func `fill with non-empty buffer succeeds`() throws {
            var bytes = [UInt8](repeating: 0, count: 32)
            try bytes.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
            // With 32 random bytes, probability of all zeros is 2^-256
            let allZero = bytes.allSatisfy { $0 == 0 }
            #expect(!allZero)
        }

        @Test func `fill with empty buffer returns immediately`() throws {
            var bytes = [UInt8]()
            try bytes.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
        }

        @Test func `fill produces different output on successive calls`() throws {
            var a = [UInt8](repeating: 0, count: 32)
            var b = [UInt8](repeating: 0, count: 32)
            try a.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
            try b.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
            #expect(a != b)
        }

        @Test func `fill single byte succeeds`() throws {
            var bytes = [UInt8](repeating: 0, count: 1)
            try bytes.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
        }

        @Test func `fill large buffer succeeds`() throws {
            var bytes = [UInt8](repeating: 0, count: 4096)
            try bytes.withUnsafeMutableBytes { buffer in
                try Random.fill(buffer)
            }
            let allZero = bytes.allSatisfy { $0 == 0 }
            #expect(!allZero)
        }
    }

#endif
