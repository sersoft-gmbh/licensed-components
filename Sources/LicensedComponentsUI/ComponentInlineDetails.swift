#if !os(macOS)
#if swift(>=6)
import SwiftUI
#else
public import SwiftUI
#endif

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
    static var previews: some View {
        NavigationView {
            ComponentInlineDetails(component: LicensedComponent(
                name: "Test Component",
                license: .mit,
                copyrightYears: "2020-2021",
                copyrightHolders: "This guy"
            ))
        }
    }
}
#endif
