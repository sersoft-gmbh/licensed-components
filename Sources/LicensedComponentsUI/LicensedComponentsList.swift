import SwiftUI
import LicensedComponents

/// Shows a list of licensed components, including showing details.
@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
public struct LicensedComponentsList: View {
    /// The components shown in this view.
    public let components: [LicensedComponent]

    #if !os(macOS)
    @State
    private var expandedComponents: Set<LicensedComponent> = []
    #endif

    /// See `View.body`
    public var body: some View {
        List {
            ForEach(components) { component in
                #if os(macOS)
                NavigationLink(
                    destination: ComponentDetailsView(component: component),
                    label: { ComponentLabel(component: component) }
                )
                #else
                HStack {
                    ComponentLabel(component: component)
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
                }
                if expandedComponents.contains(component) {
                    ComponentInlineDetails(component: component)
                        .listRowBackground(Color.gray.opacity(0.35))
                        .transition(.opacity)
                        .animation(.default)
                }
                #endif
            }
        }.groupedListStyle
    }

    /// Creates a new list using the given components.
    /// - Parameter components: The components to show.
    public init(components: [LicensedComponent]) {
        self.components = components
    }

    #if !os(macOS)
    private func toggleComponentDetails(for component: LicensedComponent) {
        withAnimation {
            if expandedComponents.contains(component) {
                expandedComponents.remove(component)
            } else {
                expandedComponents.insert(component)
            }
        }
    }
    #endif
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
fileprivate extension Color {
    static var label: Color {
        #if os(macOS)
        return Color(.labelColor)
        #else
        return Color(.label)
        #endif
    }
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
fileprivate extension View {
    #if os(macOS)
    var groupedListStyle: some View { self }
    #else
    var groupedListStyle: some View { listStyle(GroupedListStyle()) }
    #endif
}

@available(macOS 11, iOS 13, tvOS 13, watchOS 6, *)
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
