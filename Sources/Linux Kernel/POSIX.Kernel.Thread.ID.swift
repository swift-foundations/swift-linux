#if os(Linux) || os(Android) || os(OpenBSD)

    public import ISO_9945_Core
    public import ISO_9945_Kernel_Thread

    extension POSIX.Kernel.Thread {

        public typealias ID = ISO_9945.Kernel.Thread.ID
    }

#endif
