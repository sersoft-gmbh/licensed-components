import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension View {
    func platformAwareNavigationTitle<S: StringProtocol>(_ title: S) -> some View {
        // Note on AnyView usage: buildConditionalPlatformAvailability currently also uses AnyView.
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            return AnyView(navigationTitle(title))
        } else {
            #if !os(macOS)
            return AnyView(navigationBarTitle(title))
            #else
            return AnyView(self)
            #endif
        }
    }
}
