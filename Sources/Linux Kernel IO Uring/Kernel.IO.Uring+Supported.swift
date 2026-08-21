#if os(Linux)

    public import ISO_9945_Core
    public import ISO_9945_Kernel_Environment
    import POSIX_Kernel

    extension ISO_9945.Kernel.IO.Uring {

        public static var isSupported: Bool {
            _isSupported
        }

        private static let _isSupported: Bool = {
            let disabled = unsafe ISO_9945.Kernel.Environment.withValueBytes("IO_URING_DISABLED") {
                span in
                span.count == 1 && span[0] == UInt8(ascii: "1")
            }
            if disabled == true { return false }

            var params = Params()
            do throws(Self.Error) {
                let fd = try setup(entries: .one, params: &params)
                close(fd)
                return true
            } catch {
                return false
            }
        }()
    }

#endif
