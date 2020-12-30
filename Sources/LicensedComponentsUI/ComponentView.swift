import SwiftUI
import LicensedComponents

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
struct ComponentDetailsView: View {
    let component: LicensedComponent

    #if os(macOS)
    private struct FullText: Identifiable {
        let text: String

        var id: some Hashable { text }
    }

    @State
    private var fullText: FullText?
    #endif

    private var hasFullText: Bool { component.resolvedTexts.full != nil }

    var body: some View {
        #if os(macOS)
        VStack {
            if let full = component.resolvedTexts.full {
                HStack {
                    Spacer()
                    Button(action: { fullText = FullText(text: full) },
                           label: { Image(systemName: "doc.text") })
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top, .trailing], 5)
                        .popover(item: $fullText) { fullText in
                            ScrollView {
                                Text(fullText.text)
                                    .font(.system(.footnote, design: .serif))
                                    .padding()
                            }
                        }
                }
            }
            ScrollView(.vertical) {
                Text(component.resolvedTexts.short)
                    .font(.system(.body, design: .serif))
                    .padding(hasFullText ? [.horizontal, .bottom] : .all)
            }
        }
        .platformAwareNavigationTitle(component.name)
        #else
        ScrollView(hasFullText ? [.horizontal, .vertical] : .vertical) {
            if let fullText = component.resolvedTexts.full {
                Text(fullText)
                    .font(.system(.footnote, design: .serif))
                    .padding()
            } else {
                Text(component.resolvedTexts.short)
                    .font(.system(.body, design: .serif))
                    .padding()
            }
        }
        .platformAwareNavigationTitle(component.name)
        #endif
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
struct ComponentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentDetailsView(component: LicensedComponent(
                name: "Test Component",
                license: .mit,
                copyrightYears: "2020-2021",
                copyrightHolders: "This guy"
            ))
        }
        NavigationView {
            ComponentDetailsView(component: LicensedComponent(
                name: "Something else",
                license: .apache(.v2),
                copyrightYears: "2020",
                copyrightHolders: "Another guy"
            ))
        }
    }
}
