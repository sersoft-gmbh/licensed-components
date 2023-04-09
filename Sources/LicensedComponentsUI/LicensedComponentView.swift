import SwiftUI
import LicensedComponents

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
public struct LicensedComponentView: View {
    public var component: LicensedComponent

#if os(macOS)
    private struct FullText: Identifiable, Sendable {
        let text: String

        var id: some Hashable { text }
    }

    @State
    private var fullText: FullText?
#endif

    private var hasFullText: Bool { component.resolvedTexts.full != nil }

    public var body: some View {
#if os(macOS)
        VStack {
            if let full = component.resolvedTexts.full {
                HStack {
                    Spacer()
                    Button(action: { fullText = FullText(text: full) },
                           label: { Image(systemName: "doc.text") })
                    .buttonStyle(.plain)
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
            let fontDesign: Font.Design = {
                if #available(watchOS 7, *) {
                    return .serif
                } else {
                    return .default
                }
            }()
            if let fullText = component.resolvedTexts.full {
                Text(fullText)
                    .font(.system(.footnote, design: fontDesign))
                    .padding()
            } else {
                Text(component.resolvedTexts.short)
                    .font(.system(.body, design: fontDesign))
                    .padding()
            }
        }
        .platformAwareNavigationTitle(component.name)
#endif
    }

    public init(component: LicensedComponent) {
        self.component = component
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
fileprivate extension View {
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

@available(macOS 11, iOS 13, tvOS 13, watchOS 7, *)
struct LicensedComponentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicensedComponentView(component: .init(
                name: "Test Component",
                license: .mit,
                copyrightYears: "2020-2021",
                copyrightHolders: "This guy"
            ))
        }
        NavigationView {
            LicensedComponentView(component: .init(
                name: "Something else",
                license: .apache(.v2),
                copyrightYears: "2020",
                copyrightHolders: "Another guy"
            ))
        }
    }
}
