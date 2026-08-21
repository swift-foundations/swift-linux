#if os(Linux)

    public import ISO_9945_Core
    public import ISO_9945_Kernel_File

    extension ISO_9945.Kernel.File.Flush {

        @inlinable
        public static func data(
            _ descriptor: borrowing ISO_9945.Kernel.Descriptor
        ) throws(Self.Error) {
            while true {
                do throws(Self.Error) {
                    try Self.fdatasync(descriptor)
                    return
                } catch  where error.code.isInterrupted {
                    continue
                }
            }
        }
    }

#endif
