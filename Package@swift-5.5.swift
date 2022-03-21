// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "licensed-components",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LicensedComponents",
            targets: ["LicensedComponents"]),
        .library(
            name: "LicensedComponentsUI",
            targets: ["LicensedComponentsUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LicensedComponents",
            resources: [
                .copy("Resources/BundledLicenseTexts"),
            ]),
        .target(
            name: "LicensedComponentsUI",
            dependencies: ["LicensedComponents"]),
        .testTarget(
            name: "LicensedComponentsTests",
            dependencies: ["LicensedComponents"]),
    ]
)
