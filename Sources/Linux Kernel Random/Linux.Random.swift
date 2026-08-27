#if os(Linux)

    extension Linux {

        public typealias Random = Random.Random
    }

    extension Random {

        public static func fill(
            _ buffer: UnsafeMutableRawBufferPointer
        ) throws(Error) {
            try unsafe Linux.Kernel.Random.getrandom(buffer)
        }
    }

#endif
