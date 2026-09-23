#if !os(macOS)
import SwiftUI
import LicensedComponents

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
struct ComponentInlineDetails: View {
    var component: LicensedComponent

    var body: some View {
        Text(component.resolvedTexts.short)
            .font(.footnote)
        if component.resolvedTexts.full != nil {
            NavigationLink(
                destination: LicensedComponentView(component: component),
                label: {
                    HStack {
                        Spacer()
                        Image(systemName: "doc.text")
                    }
                })
                .listItemTintMonochrome
        }
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
fileprivate extension View {
    @ViewBuilder
    var listItemTintMonochrome: some View {
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            listItemTint(.monochrome)
        } else {
            self
        }
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 7, *)
struct ComponentInlineDetails_Previews: PreviewProvider {
    private static var details: some View {
        List {
            ComponentInlineDetails(component: LicensedComponent(
                name: "Test Component",
                license: .mit,
                copyrightYears: "2020-2021",
                copyrightHolders: "This guy"
            ))
            ComponentInlineDetails(component: LicensedComponent(
                name: "Test Component 2",
                license: .gpl(.v3),
                copyrightYears: "2022-2025",
                copyrightHolders: "This other guy"
            ))
        }
    }

    static var previews: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack {
                details
            }
        } else {
            NavigationView {
                details
            }
        }
    }
}
#endif
