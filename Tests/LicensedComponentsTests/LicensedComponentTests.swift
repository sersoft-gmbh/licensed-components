import Foundation
import Testing
@testable import LicensedComponents
#if canImport(SwiftUI)
fileprivate let swiftUIAvailable = true
#else
fileprivate let swiftUIAvailable = false
#endif

@Suite
struct LicensedComponentTests {
    @Test
    func creation() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        #expect(component.name == "Test Component")
        #expect(component.license == .apache(.v2))
        #expect(component.copyrightYears == "2020-2021")
        #expect(component.copyrightHolders == "Tester")
    }

    @Test
    func hashableConformance() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        let component2 = LicensedComponent(name: "Test Component",
                                           license: .apache(.v2),
                                           copyrightYears: "2020-2021",
                                           copyrightHolders: "Tester")
        #expect(component == component2)
        #expect(component.hashValue == component2.hashValue)
    }

    @Test
    func identifiableConformance() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        #expect(component.id as? LicensedComponent == component)
    }

    @Test(.enabled(if: swiftUIAvailable))
    func dynamicPropertyConformance() throws {
#if canImport(SwiftUI)
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        component.update()
        #expect(component._storage._resolvedTexts != nil)
#endif
    }

    @Test
    func nundledLicences() {
        let mit = LicensedComponent(name: "Test Component",
                                    license: .mit,
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        #expect(mit.license.title == "MIT")
        #expect(mit.baseTexts.short.hasPlaceholders)
        #expect(!mit.baseTexts.short.string.isEmpty)
        #expect(mit.baseTexts.full == nil)

        let apacheV2 = LicensedComponent(name: "Test Component",
                                    license: .apache(.v2),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        #expect(apacheV2.license.title == "Apache v2")
        #expect(apacheV2.baseTexts.short.hasPlaceholders)
        #expect(!apacheV2.baseTexts.short.string.isEmpty)
        #expect(apacheV2.baseTexts.full != nil)
        #expect(apacheV2.baseTexts.full?.string.isEmpty == false)
        #expect(apacheV2.baseTexts.full?.hasPlaceholders == false)

        let bsd3Clause = LicensedComponent(name: "Test Component",
                                           license: .bsd(.threeClause),
                                           copyrightYears: "2020-2021",
                                           copyrightHolders: "Tester")
        #expect(bsd3Clause.license.title == "BSD 3-Clause")
        #expect(bsd3Clause.baseTexts.short.hasPlaceholders)
        #expect(!bsd3Clause.baseTexts.short.string.isEmpty)
        #expect(bsd3Clause.baseTexts.full == nil)

        let gplV3 = LicensedComponent(name: "Test Component",
                                    license: .gpl(.v3),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        #expect(gplV3.license.title == "GPL v3")
        #expect(gplV3.baseTexts.short.hasPlaceholders)
        #expect(!gplV3.baseTexts.short.string.isEmpty)
        #expect(gplV3.baseTexts.full != nil)
        #expect(gplV3.baseTexts.full?.string.isEmpty == false)
        #expect(gplV3.baseTexts.full?.hasPlaceholders == false)
    }

    @Test
    func customLicense() {
        let customTexts = LicensedComponent.LicenseTexts(short: .init("%year% anyway", hasPlaceholders: true),
                                                        full: .init("Nope", hasPlaceholders: false))
        let custom = LicensedComponent(name: "Test Component",
                                    license: .custom(title: "Custom", customTexts),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        #expect(custom.license.title == "Custom")
        #expect(custom.baseTexts == customTexts)
    }

    @Test
    func textResolving() {
        let customTexts = LicensedComponent.LicenseTexts(short: .init("%year% anyway", hasPlaceholders: true), full: nil)
        let custom = LicensedComponent(name: "Test Component",
                                    license: .custom(title: "Custom", customTexts),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        #expect(!custom.resolvedTexts.short.contains("%year%"))
    }
}
