import XCTest
@testable import LicensedComponents

final class LicensedComponentTests: XCTestCase {
    func testCreation() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        XCTAssertEqual(component.name, "Test Component")
        XCTAssertEqual(component.license, .apache(.v2))
        XCTAssertEqual(component.copyrightYears, "2020-2021")
        XCTAssertEqual(component.copyrightHolders, "Tester")
    }

    func testHashableConformance() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        let component2 = LicensedComponent(name: "Test Component",
                                           license: .apache(.v2),
                                           copyrightYears: "2020-2021",
                                           copyrightHolders: "Tester")
        XCTAssertEqual(component, component2)
        XCTAssertEqual(component.hashValue, component2.hashValue)
    }

    func testIdentifiableConformance() {
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        XCTAssertEqual(component.id as? LicensedComponent, component)
    }

    func testDynamicPropertyConformance() throws {
        #if canImport(SwiftUI) && canImport(Combine)
        let component = LicensedComponent(name: "Test Component",
                                          license: .apache(.v2),
                                          copyrightYears: "2020-2021",
                                          copyrightHolders: "Tester")
        component.update()
        XCTAssertNotNil(component._storage.resolvedTexts)
        #else
        throw XCTSkip("API is unavailable on this platform.")
        #endif
    }

    func testBundledLicences() {
        let mit = LicensedComponent(name: "Test Component",
                                    license: .mit,
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        XCTAssertEqual(mit.license.title, "MIT")
        XCTAssertTrue(mit.baseTexts.short.hasPlaceholders)
        XCTAssertFalse(mit.baseTexts.short.string.isEmpty)
        XCTAssertNil(mit.baseTexts.full)

        let apacheV2 = LicensedComponent(name: "Test Component",
                                    license: .apache(.v2),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        XCTAssertEqual(apacheV2.license.title, "Apache v2")
        XCTAssertTrue(apacheV2.baseTexts.short.hasPlaceholders)
        XCTAssertFalse(apacheV2.baseTexts.short.string.isEmpty)
        XCTAssertNotNil(apacheV2.baseTexts.full)
        XCTAssertEqual(apacheV2.baseTexts.full?.string.isEmpty, false)
        XCTAssertEqual(apacheV2.baseTexts.full?.hasPlaceholders, false)

        let bsd3Clause = LicensedComponent(name: "Test Component",
                                           license: .bsd(.threeClause),
                                           copyrightYears: "2020-2021",
                                           copyrightHolders: "Tester")
        XCTAssertEqual(bsd3Clause.license.title, "BSD 3-Clause")
        XCTAssertTrue(bsd3Clause.baseTexts.short.hasPlaceholders)
        XCTAssertFalse(bsd3Clause.baseTexts.short.string.isEmpty)
        XCTAssertNil(bsd3Clause.baseTexts.full)

        let gplV3 = LicensedComponent(name: "Test Component",
                                    license: .gpl(.v3),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        XCTAssertEqual(gplV3.license.title, "GPL v3")
        XCTAssertTrue(gplV3.baseTexts.short.hasPlaceholders)
        XCTAssertFalse(gplV3.baseTexts.short.string.isEmpty)
        XCTAssertNotNil(gplV3.baseTexts.full)
        XCTAssertEqual(gplV3.baseTexts.full?.string.isEmpty, false)
        XCTAssertEqual(gplV3.baseTexts.full?.hasPlaceholders, false)
    }

    func testCustomLicense() {
        let customTexts = LicensedComponent.LicenseTexts(short: .init("%year% anyway", hasPlaceholders: true),
                                                        full: .init("Nope", hasPlaceholders: false))
        let custom = LicensedComponent(name: "Test Component",
                                    license: .custom(title: "Custom", customTexts),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        XCTAssertEqual(custom.license.title, "Custom")
        XCTAssertEqual(custom.baseTexts, customTexts)
    }

    func testTextResolving() {
        let customTexts = LicensedComponent.LicenseTexts(short: .init("%year% anyway", hasPlaceholders: true), full: nil)
        let custom = LicensedComponent(name: "Test Component",
                                    license: .custom(title: "Custom", customTexts),
                                    copyrightYears: "2020-2021",
                                    copyrightHolders: "Tester")
        XCTAssertFalse(custom.resolvedTexts.short.contains("%year%"))
    }
}
