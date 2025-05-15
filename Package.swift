// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: Array<SwiftSetting> = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
]

let package = Package(
    name: "licensed-components",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
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
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LicensedComponents",
            resources: [
                .copy("Resources/BundledLicenseTexts"),
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "LicensedComponentsUI",
            dependencies: ["LicensedComponents"],
            swiftSettings: swiftSettings),
        .testTarget(
            name: "LicensedComponentsTests",
            dependencies: ["LicensedComponents"],
            swiftSettings: swiftSettings),
    ]
)
