import Linux_Kernel_Thread
import Testing

extension Linux.Thread {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

extension Linux.Thread.Test.Unit {
    @Test func `namespace exists`() {

        _ = Linux.Thread.self
    }
}
