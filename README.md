# Orchard

[![Swift](https://github.com/kibotu/Orchard/actions/workflows/build-swift.yml/badge.svg)](https://github.com/kibotu/Orchard/actions/workflows/build-swift.yml)
[![Release](https://img.shields.io/github/v/tag/kibotu/Orchard?include_prereleases&sort=semver)](https://github.com/kibotu/Orchard/releases)
![Swift 6](https://img.shields.io/badge/Swift-6-orange)
![Platforms](https://img.shields.io/badge/iOS%2015%20%7C%20macOS%2012%20%7C%20tvOS%2015%20%7C%20watchOS%208%20%7C%20visionOS%201-lightgrey)

Small, tag-and-icon-friendly logging for Swift. Log once; send it to as many places as you like.

```swift
Orchard.loggers.append(ConsoleLogger())

Orchard.tag("Payment").icon("💳").i("Charged", ["amount": "99.99"])
// 💳 13:54:48.403: [Payment/Checkout.pay():42] Charged {"amount":"99.99"}
```

Orchard is inspired by [Timber](https://github.com/JakeWharton/timber): a tiny call site, pluggable backends, and no opinion about where your logs end up. It has no dependencies beyond Foundation.

[![Demo app](docs/screenshot.png)](Examples/)

## Why Orchard

- **One call site.** `Orchard.i(...)` everywhere; swap or add backends without touching feature code.
- **Backends are yours.** Implement `Orchard.Logger` for files, crash reporters, or analytics. The bundled `ConsoleLogger` is optional.
- **Context where you need it.** Tags, icons, an optional error, and key-value arguments, in any combination.
- **Call-site capture.** File, function, and line come for free.
- **Concurrency-aware.** Built in Swift 6 language mode; tag and icon state is lock-protected.
- **Light.** One module, Foundation only.

## Installation

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/kibotu/Orchard", from: "<latest-version>"),
],
targets: [
    .target(name: "YourTarget", dependencies: ["Orchard"]),
]
```

Or in Xcode: **File → Add Package Dependencies…** and enter `https://github.com/kibotu/Orchard`.

## Usage

Register loggers once, early in your app's lifecycle:

```swift
import Orchard

Orchard.loggers.append(ConsoleLogger())
```

Then log. Message, error, and arguments are all optional and combine freely:

```swift
Orchard.i("App started")
Orchard.e(error)
Orchard.e("Failed to load", error)
Orchard.i("Tapped", ["button": "submit"])
Orchard.e("Request failed", error, ["url": "api.example.com", "method": "POST"])
```

Six levels, each with its own icon: `v` 🔬 · `d` 🔍 · `i` ℹ️ · `w` ⚠️ · `e` ❌ · `f` ⚡️

### Tags and icons

A tag or icon applies to the next log call only:

```swift
Orchard.tag("Network").i("Connected")
Orchard.icon("🚀").i("Launched")
Orchard.tag("API").icon("🔥").e("Critical failure", error, ["status": "500"])
```

### Arguments

Arguments are rendered as sorted-key JSON. Values that JSON cannot represent are logged using their `description`, so a log call never takes your app down.

### Configuring `ConsoleLogger`

```swift
let logger = ConsoleLogger { config in
    config.timestampFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    config.showInvocation = false
    config.moduleNameMapper = { $0.replacingOccurrences(of: "MyApp", with: "App") }
}
Orchard.loggers.append(logger)
```

| Option | Default | Effect |
|---|---|---|
| `showTimestamp` | `true` | Prefix each line with a timestamp |
| `timestampFormat` | `"HH:mm:ss.SSS"` | `DateFormatter` format string |
| `showInvocation` | `true` | Append `/File.function:line` |
| `moduleNameMapper` | `nil` | Rewrite the module name shown in the brackets |

`ConsoleLoggerConfig` can also be built directly and passed to `ConsoleLogger(config:)`, or changed later via `logger.config`.

### Writing your own logger

Conform to `Orchard.Logger`. A logger decides for itself what to do with each call, and `level` is the minimum severity it cares about:

```swift
final class CrashReportLogger: Orchard.Logger {
    let level: Orchard.Level = .error
    var tag: String?
    var icon: Character?

    func verbose(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {}
    func debug(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {}
    func info(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {}
    func warning(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {}

    func error(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        // forward to your crash reporter
    }

    func fatal(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        error(message, error, args, file, fileId, function, line)
    }
}
```

For tests, `Orchard.loggers` is a plain array: swap in a recording logger and assert on what it received.

## Good to know

- Add loggers at startup. `Orchard.loggers` is a plain array and is not synchronized, so avoid mutating it while other threads are logging.
- A tag or icon is shared state until the next log call consumes it. Chain it directly onto the call, as in the examples above.
- Logs are not redacted. Keep secrets and personal data out of messages and arguments.

## Demo app

An interactive SwiftUI app lives in [`Examples/OrchardDemo`](Examples/). Open the project and press **⌘R**.

## Requirements

- iOS 15, macOS 12, tvOS 15, watchOS 8, or visionOS 1
- Swift 6 toolchain (Xcode 16 or later; CI runs on the latest Xcode)

See also: [how Orchard compares to other loggers](comparision-to-other-loggers.md).

Contributions are welcome. Please run `swift test` and `swiftlint` before opening a pull request.

### License
<pre>
Copyright 2024 Jan Rabe & CHECK24

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>
