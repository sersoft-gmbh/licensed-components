import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension View {
    @ViewBuilder
    func platformAwareNavigationTitle<S: StringProtocol>(_ title: S) -> some View {
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            navigationTitle(title)
        } else {
            #if !os(macOS)
            navigationBarTitle(title)
            #else
            self
            #endif
        }
    }
}
