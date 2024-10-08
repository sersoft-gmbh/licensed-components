#if swift(>=6.0)
// must be internal, cause the compiler generated resource_bundle_accessor.swift imports it as internal
internal import Foundation
#else
// Older Swift versions don't have the implicit internal flag. Just import it there.
import Foundation
#endif

/// Represents a licensed component.
public struct LicensedComponent: Hashable, Identifiable {
    @usableFromInline
    struct _CopyrightDetails: Sendable, Hashable {
        @usableFromInline
        let licensedProduct: String
        @usableFromInline
        let years: String
        @usableFromInline
        let holders: String
    }

    @usableFromInline
    final class _Storage {
        @usableFromInline
        let license: License
        @usableFromInline
        let details: _CopyrightDetails

        @usableFromInline
        private(set) lazy var baseTexts = license._baseTexts
        @usableFromInline
        private(set) lazy var resolvedTexts = baseTexts._resolve(with: details)

        init(license: License, details: _CopyrightDetails) {
            self.license = license
            self.details = details
        }
    }

    @usableFromInline
    let _storage: _Storage

    /// The name of the component. Example: `Licensed Components`
    @inlinable
    public var name: String { _storage.details.licensedProduct }

    /// The license of the component.
    /// - SeeAlso: ``LicensedComponent/License``
    @inlinable
    public var license: License { _storage.license }

    /// The years the copyright applies to. Example: `"2020-2021"`
    @inlinable
    public var copyrightYears: String { _storage.details.years }

    /// The holders of the copyright. Example: `"ser.soft GmbH"`
    @inlinable
    public var copyrightHolders: String { _storage.details.holders }

    /// The base license texts. If the texts have placeholders, they weren't filled.
    @inlinable
    public var baseTexts: LicenseTexts { _storage.baseTexts }

    /// The resolved license texts. If the texts have placeholders, they were replaced.
    @inlinable
    public var resolvedTexts: LicenseTexts.Resolved { _storage.resolvedTexts }

    public var id: some Hashable { self }

    /// Creates a new licensed component using the given parameters.
    /// - Parameters:
    ///   - name: The name of the component, e.g. `"Licensed Components"`
    ///   - license: The license of this component, e.g. `.apache(.v2)`
    ///   - copyrightYears: The years the copyright applies to, e.g. `"2020-2021"`
    ///   - copyrightHolders: The holders of the copyright, e.g. `"ser.soft GmbH"`
    public init(name: String,
                license: License,
                copyrightYears: String,
                copyrightHolders: String) {
        _storage = .init(license: license,
                         details: .init(licensedProduct: name,
                                        years: copyrightYears,
                                        holders: copyrightHolders))
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_storage.license)
        hasher.combine(_storage.details)
    }

    public static func ==(lhs: LicensedComponent, rhs: LicensedComponent) -> Bool {
        (lhs._storage.license, lhs._storage.details) == (rhs._storage.license, rhs._storage.details)
    }
}

#if arch(arm64) || arch(x86_64)
#if canImport(SwiftUI) && canImport(Combine)
public import SwiftUI

extension LicensedComponent: DynamicProperty {
    public func update() {
        // We use the side effect of the lazy var here.
        _ = _storage.resolvedTexts
    }
}
#endif
#endif

extension LicensedComponent {
    /// Contains the texts of a license.
    /// For some "known" licenses, this package already bundles the text (see ``LicensedComponent/License``).
    /// Each license can have a short text and the full license text. The short text should not exceed a certain length.
    /// If the full license text fits into the short text, ``LicenseTexts/full`` can be set to `nil`.
    public struct LicenseTexts: Sendable, Hashable {
        /// The resolved (enriched) version of the license texts where placeholders have been replaced with the corresponding values.
        public struct Resolved: Sendable, Hashable {
            /// The resolved short license text.
            public let short: String
            /// The resolved full license text.
            public let full: String?
        }

        /// This represents an unresolved license text. Unresolved means that the text is allowed to have certain placeholders.
        /// This package will automatically fill those with the corresponding values of ``LicensedComponent``.
        ///
        /// The following placeholders are available:
        /// - `%year%` - Will be replaced with ``LicensedComponent/copyrightYears``
        /// - `%copyrightholders%` - Will be replaced with ``LicensedComponent/copyrightHolders``
        /// - `%productname%` - Will be replaced with ``LicensedComponent/name``
        ///
        /// - Note: If you provide a custom text and don't have any placeholders,
        ///         pass `false` to `hasPlaceholders` to prevent any string manipulation.
        public struct Text: Sendable, Hashable {
            /// The string of this text.
            public let string: String
            /// Whether `string` contains placeholders.
            public let hasPlaceholders: Bool

            /// Creates a new text with the given parameters.
            /// - Parameters:
            ///   - string: The string of this text.
            ///   - hasPlaceholders: Whether `string` has placeholders.
            public init(_ string: String, hasPlaceholders: Bool) {
                self.string = string
                self.hasPlaceholders = hasPlaceholders
            }

            func _resolve(with details: _CopyrightDetails) -> String {
                guard hasPlaceholders else { return string }
                return string
                    .replacingOccurrences(of: "%productname%", with: details.licensedProduct)
                    .replacingOccurrences(of: "%year%", with: details.years)
                    .replacingOccurrences(of: "%copyrightholders%", with: details.holders)
            }
        }

        /// The short license text.
        public let short: Text
        /// The full license text.
        public let full: Text?

        /// Creates new license texts with the given paremeters.
        /// - Parameters:
        ///   - short: The short license text.
        ///   - full: The full license text. Defaults to `nil`.
        public init(short: Text, full: Text? = nil) {
            self.short = short
            self.full = full
        }

        func _resolve(with details: _CopyrightDetails) -> Resolved {
            .init(short: short._resolve(with: details),
                  full: full?._resolve(with: details))
        }
    }
}

extension LicensedComponent {
    /// Describes a license.
    public enum License: Sendable, Hashable {
        /// The Apache license versions.
        public enum Apache: Sendable, Hashable {
            /// Version 2.0 of the Apache license.
            case v2
        }

        /// The BSD license versions.
        public enum BSD: Sendable, Hashable {
            /// The 3-Clause version of the BSD license.
            case threeClause
        }

        /// The GPL license versions.
        public enum GPL: Sendable, Hashable {
            /// Version 3.0 of the GPL license.
            case v3
        }

        /// The MIT license.
        case mit
        /// A version of the Apache license.
        case apache(Apache)
        /// A version of the BSD license.
        case bsd(BSD)
        /// A version of the GPL license.
        case gpl(GPL)

        /// A custom license. Use this for licenses not (yet) bundled in this package.
        case custom(title: String, LicenseTexts)

        /// The title of the license.
        public var title: String {
            switch self {
            case .mit: "MIT"
            case .apache(.v2): "Apache v2"
            case .bsd(.threeClause): "BSD 3-Clause"
            case .gpl(.v3): "GPL v3"
            case .custom(let title, _): title
            }
        }
    }
}

// Mark: - Bundled License Texts
extension LicensedComponent.LicenseTexts {
    private static let bundledLicenseTextsDirectory = Bundle.module.url(forResource: "BundledLicenseTexts", withExtension: nil)!

    fileprivate static func bundled(inDirectory directoryPath: String,
                                    hasFull: Bool = true,
                                    shortHasPlaceholders: Bool = true,
                                    fullHasPlaceholders: Bool = false) -> Self {
        let folderPath = bundledLicenseTextsDirectory.appendingPathComponent(directoryPath, isDirectory: true)
        do {
            let short = try String(contentsOf: folderPath.appendingPathComponent("short.txt", isDirectory: false), encoding: .utf8)
            let full = hasFull ? try String(contentsOf: folderPath.appendingPathComponent("full.txt", isDirectory: false), encoding: .utf8) : nil
            return .init(short: .init(short, hasPlaceholders: shortHasPlaceholders),
                         full: full.map { .init($0, hasPlaceholders: fullHasPlaceholders) })
        } catch {
            fatalError("Failed to load bundled license text: \(error)")
        }
    }
}

extension LicensedComponent.License {
    var _baseTexts: LicensedComponent.LicenseTexts {
        switch self {
        case .mit: .bundled(inDirectory: "MIT", hasFull: false)
        case .apache(.v2): .bundled(inDirectory: "Apache/v2")
        case .bsd(.threeClause): .bundled(inDirectory: "BSD/3Clause", hasFull: false)
        case .gpl(.v3): .bundled(inDirectory: "GPL/v3")
        case .custom(_, let texts): texts
        }
    }
}
