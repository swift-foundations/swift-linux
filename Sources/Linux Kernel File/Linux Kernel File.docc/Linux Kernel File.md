# ``Linux_Kernel_File``

@Metadata {
    @DisplayName("Linux Kernel File")
    @TitleHeading("Swift Foundations")
}

The Linux-specific completion of the ISO 9945 (POSIX) kernel file-flush
policy: `ISO_9945.Kernel.File.Flush.data(_:)`, backed by `fdatasync(2)` — a
syscall POSIX specifies but Darwin does not implement, so this
data-only-durability policy lives only in the Linux-specific package.

## When to use this

Reach for this package when code needs `ISO_9945.Kernel.File.Flush.data(_:)`
to actually run on Linux — it supplies the Linux-specific body (retrying on
`EINTR`) behind the cross-platform `ISO_9945.Kernel.File.Flush` name that
higher layers depend on. Code that only needs the flush names themselves,
portable across platforms, should depend on `swift-iso-9945` directly rather
than this package; reach for the companion in `swift-darwin` for the
Darwin-specific policy (which has no `fdatasync` equivalent).

## Topics

### Related packages

- [swift-iso-9945](https://github.com/swift-iso/swift-iso-9945) — the
  cross-platform POSIX kernel spec this package completes for Linux.
- [swift-darwin](https://github.com/swift-foundations/swift-darwin) — the
  Darwin-specific companion for the same shared `ISO_9945.Kernel.File.Flush`
  namespace.
