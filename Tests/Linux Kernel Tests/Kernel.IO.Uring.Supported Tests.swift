import Linux_Kernel
import Linux_Kernel_IO_Uring
import Testing

#if os(Linux)

    extension Kernel.IO.Uring {
        @Suite
        struct Test {
            @Suite struct Unit {}
        }
    }

    extension Kernel.IO.Uring.Test.Unit {
        @Test func `isSupported returns a Bool`() {
            let result: Bool = Kernel.IO.Uring.isSupported

            _ = result
        }

        @Test func `isSupported is stable across calls`() {
            let first = Kernel.IO.Uring.isSupported
            let second = Kernel.IO.Uring.isSupported
            #expect(first == second)
        }
    }

#endif
