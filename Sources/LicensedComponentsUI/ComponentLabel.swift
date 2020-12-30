import SwiftUI

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
struct ComponentLabel: View {
    let component: LicensedComponent

    var body: some View {
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
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
struct ComponentLabel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentLabel(component: LicensedComponent(
                name: "Test Component",
                license: .mit,
                copyrightYears: "2020-2021",
                copyrightHolders: "This guy"
            ))
        }
    }
}
