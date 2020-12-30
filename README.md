# Licensed Components

[![GitHub release](https://img.shields.io/github/release/sersoft-gmbh/licensed-components.svg?style=flat)](https://github.com/sersoft-gmbh/licensed-components/releases/latest)
![Tests](https://github.com/sersoft-gmbh/licensed-components/workflows/Tests/badge.svg)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/52b18112086f404a9f970b8b7a7c4529)](https://www.codacy.com/gh/sersoft-gmbh/licensed-components/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=sersoft-gmbh/licensed-components&amp;utm_campaign=Badge_Grade)
[![codecov](https://codecov.io/gh/sersoft-gmbh/licensed-components/branch/main/graph/badge.svg?token=SYWM5R6N7G)](https://codecov.io/gh/sersoft-gmbh/licensed-components)
[![jazzy](https://raw.githubusercontent.com/sersoft-gmbh/licensed-components/gh-pages/badge.svg?sanitize=true)](https://sersoft-gmbh.github.io/licensed-components)

A simple package containing models and UI for listing open source components.

## Installation

Add the following dependency to your `Package.swift`:
```swift
.package(url: "https://github.com/sersoft-gmbh/licensed-components.git", from: "1.0.0"),
```

Or add it via Xcode (as of Xcode 11).

## Usage

Licensed Components contains two targets: `LicensedComponents` and `LicensedComponentsUI`.
The former contains the model `LicensedComponent` and the latter contains SwiftUI views for listing them.

To use the UI, simply pass a list of `LicensedComponent`s to the `LicensedComponentsList`:

```swift
import SwiftUI

struct ContentView: View {
    private let components: [LicensedComponent] = [
        LicensedComponent(
            name: "Licensed Components",
            license: .apache(.v2),
            copyrightYears: "2020-2021",
            copyrightHolders: "ser.soft GmbH"
        ),
        LicensedComponent(
            name: "Color Components",
            license: .apache(.v2),
            copyrightYears: "2020-2021",
            copyrightHolders: "ser.soft GmbH"
        ),
        LicensedComponent(
            name: "CocoaLumberjack",
            license: .bsd(.threeClause),
            copyrightYears: "2010-2021",
            copyrightHolders: "Deusty, LLC"
        )
    ]

    var body: some View {
        NavigationView {
            LicensedComponentsList(components: components)
        }
    }
}
```

<!--
## Possible Features

While not yet integrated, the following features might provide added value and could make it into this package in the future:

-   
-->

## Documentation

The API is documented using header doc. If you prefer to view the documentation as a webpage, there is an [online version](https://sersoft-gmbh.github.io/licensed-components) available for you.

## Contributing

If you find a bug / like to see a new feature in this package there are a few ways of helping out:

-   If you can fix the bug / implement the feature yourself please do and open a PR.
-   If you know how to code (which you probably do), please add a (failing) test and open a PR. We'll try to get your test green ASAP.
-   If you can do neither, then open an issue. While this might be the easiest way, it will likely take the longest for the bug to be fixed / feature to be implemented.

## License

See [LICENSE](./LICENSE) file.

For integrating as `LicensedComponent`:
```swift
LicensedComponent(
    name: "Licensed Components",
    license: .apache(.v2),
    copyrightYears: "2020-2021",
    copyrightHolders: "ser.soft GmbH"
)
```
