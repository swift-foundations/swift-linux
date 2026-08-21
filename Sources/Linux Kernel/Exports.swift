@_exported public import Linux_Kernel_Descriptor
@_exported public import Linux_Kernel_Event
@_exported public import Linux_Kernel_File
@_exported public import Linux_Kernel_Futex
@_exported public import Linux_Kernel_IO
@_exported public import Linux_Kernel_IO_Uring
@_exported public import Linux_Kernel_Memory
@_exported public import Linux_Kernel_Pipe
@_exported public import Linux_Kernel_Random
@_exported public import Linux_Kernel_Socket
@_exported public import Linux_Kernel_System
@_exported public import Linux_Kernel_Thread
@_exported public import POSIX_Kernel

public typealias Kernel = POSIX.Kernel

public typealias Linux = Linux_Kernel_System_Standard.Linux

#if os(Linux)

    public import ISO_9945_Core
    extension POSIX.Kernel.IO {
        public typealias Uring = ISO_9945.Kernel.IO.Uring
    }
#endif
