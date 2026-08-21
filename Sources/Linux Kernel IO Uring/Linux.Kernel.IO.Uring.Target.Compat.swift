#if os(Linux)

    public import ISO_9945_Core
    @_spi(Syscall) public import Linux_Kernel_IO_Uring_Standard

    extension ISO_9945.Kernel.IO.Uring.Target {

        @_lifetime(borrow fd)
        public init(descriptor fd: borrowing ISO_9945.Kernel.Descriptor) {
            self = .descriptor(fd._rawValue)
        }
    }

#endif
