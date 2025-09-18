public import SwiftUI
public import LicensedComponents

/// Shows a list of licensed components, including showing details.
@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
public struct LicensedComponentsList: View {
    /// The components shown in this view.
    public var components: Array<LicensedComponent>

#if !(os(macOS) || os(watchOS))
    @State
    private var expandedComponents = Set<LicensedComponent>()
#endif

    public var body: some View {
        List {
            ForEach(components) { component in
#if os(macOS) || os(watchOS)
                NavigationLink(
                    destination: LicensedComponentView(component: component),
                    label: { LicensedComponentLabel(component: component) }
                )
#elseif compiler(>=6.0) // currently needed to work around a Swift 6.0 bug
                HStack {
                    LicensedComponentLabel(component: component)
                    Spacer()
                    Button(action: { toggleComponentDetails(for: component) },
                           label: {
                        Image(systemName: "chevron.right")
                            .accentColor(.label)
                            .rotationEffect(
                                expandedComponents.contains(component)
                                ? .init(degrees: 90)
                                : .zero
                            )
                    })
                    .animation(.default, value: expandedComponents.contains(component))
                }
                if expandedComponents.contains(component) {
#if compiler(>=6.2)
                    unsafe ComponentInlineDetails(component: component)
                        .listRowBackground(Color.gray.opacity(0.35))
                        .transition(.opacity)
#else
                    ComponentInlineDetails(component: component)
                        .listRowBackground(Color.gray.opacity(0.35))
                        .transition(.opacity)
#endif
                }
#endif
            }
        }
#if !(os(macOS) || os(watchOS))
        .animation(.default, value: expandedComponents)
        .listStyle(.grouped)
#endif
    }

    /// Creates a new list using the given components.
    /// - Parameter components: The components to show.
    public init(components: Array<LicensedComponent>) {
        self.components = components
    }

#if !(os(macOS) || os(watchOS))
    private func toggleComponentDetails(for component: LicensedComponent) {
        if expandedComponents.contains(component) {
            expandedComponents.remove(component)
        } else {
            expandedComponents.insert(component)
        }
    }
#endif
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
fileprivate extension Color {
    static var label: Color {
#if os(macOS)
        if #available(macOS 12, *) {
            return Color(nsColor: .labelColor)
        } else {
            return Color(.labelColor)
        }
#elseif os(watchOS)
            return primary
#else
        if #available(iOS 15, tvOS 15, *) {
            return Color(uiColor: .label)
        } else {
            return Color(.label)
        }
#endif
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 7, *)
struct LicensedComponentsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicensedComponentsList(components: [
                LicensedComponent(
                    name: "Test Component",
                    license: .custom(
                        title: "Test License",
                        .init(
                            short: .init(String(repeating: "Only short\n",
                                                count: 12),
                                         hasPlaceholders: false)
                        )
                    ),
                    copyrightYears: "2020-2021",
                    copyrightHolders: "This guy"
                ),
                LicensedComponent(
                    name: "Something else",
                    license: .custom(
                        title: "Test License",
                        .init(
                            short: .init(String(repeating: "Also long short\n",
                                                count: 12),
                                         hasPlaceholders: false),
                            full: .init(String(repeating: "A very long license text\n",
                                               count: 40),
                                        hasPlaceholders: false)
                        )
                    ),
                    copyrightYears: "2020",
                    copyrightHolders: "Another guy"
                ),
            ])
        }
    }
}
