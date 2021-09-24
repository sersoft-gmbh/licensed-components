#if arch(arm64) || arch(x86_64)
#if !canImport(SwiftUI) || !canImport(Combine)
#error("Unsupported platform for this target")
#endif
#endif
