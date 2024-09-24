public import SwiftUI

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
public struct LicensedComponentLabel: View {
    public var component: LicensedComponent

    public var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(component.name)
                .font(.headline)
            HStack(spacing: 3) {
                Image(systemName: "book.closed")
                Text(component.license.title).italic()
            }
            .font(.footnote)
        }
    }

    public init(component: LicensedComponent) {
        self.component = component
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 7, *)
struct LicensedComponentLabel_Previews: PreviewProvider {
    static var previews: some View {
        LicensedComponentLabel(component: .init(
            name: "Test Component",
            license: .mit,
            copyrightYears: "2020-2021",
            copyrightHolders: "This guy"
        ))
    }
}
