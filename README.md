# Orchard for iOS
[![Build](https://github.com/kibotu/Orchard/actions/workflows/build-swift.yml/badge.svg)](https://github.com/kibotu/Orchard/actions/workflows/build-swift.yml) [![GitHub Tag](https://img.shields.io/github/v/tag/kibotu/Orchard?include_prereleases&sort=semver)](https://github.com/kibotu/Orchard/releases) ![Static Badge](https://img.shields.io/badge/Platform%20-%20iOS%20-%20light_green)
[![Static Badge](https://img.shields.io/badge/iOS%20-%20%3E%2016.0%20-%20light_green)](https://support.apple.com/en-us/101566)
[![Static Badge](https://img.shields.io/badge/Swift%205.10%20-%20orange)](https://www.swift.org/blog/swift-5.10-released/)

Welcome to **Orchard** - your new best friend for logging on iOS! 🍏📱

Inspired by the clever wordplay behind Timber, the Android logging system (logs and timber, get it?), we decided to bring a slice of that punny brilliance to iOS with Orchard. After all, what's more fitting than logging apples in the world of iPhones?

But let's get serious for a moment. Just because you're developing on iOS doesn't mean your logging has to be... shall we say, subpar? With Orchard, you can elevate your logging game with style and efficiency.

Orchard is a versatile logging system for Swift applications, designed to provide flexible and contextual logging capabilities.

## Key Features

- Multiple log levels: verbose, debug, info, warning, error, and fatal
- Support for multiple logging backends
- Contextual logging with tags and custom icons
- Automatic capture of file, function, and line information
- Optional timestamp logging
- Customizable log formatting
- Thread-safe logging operations

## 📱 Demo App

Want to see Orchard in action? Check out the **iOS Demo App**:

```bash
cd Examples/OrchardDemo
open OrchardDemo.xcodeproj
```

Press **⌘+R** in Xcode to run the interactive demo with live log display!

[See Examples →](Examples/)

### Setup

1. Add the Orchard package to your Swift project.
2. Import Orchard in your Swift files:
```swift
import Orchard
```
3. Add loggers to the Orchard system
```swift
Orchard.loggers.append(ConsoleLogger())
```
### Basic Usage

```swift
// Simple log message
Orchard.i("User logged in successfully")

// Log with additional context
Orchard.e("Failed to save data", error, ["userId": user.id])

// Use tags for categorization
Orchard.tag("NetworkManager").d("Request started")

// Custom icons
Orchard.icon("🚀").i("App launched")

// Focus on convenience

// log only messages
Orchard.v("verbose")
Orchard.i("info")
Orchard.d("debug")
Orchard.w("warning")
Orchard.e("error")
Orchard.f("fatal")

// only errors        
let error = HttpError.blacklisted
Orchard.v(error)
Orchard.i(error)
Orchard.d(error)
Orchard.w(error)
Orchard.e(error)
Orchard.f(error)

// messages and errors
Orchard.v("verbose", error)
Orchard.i("info", error)
Orchard.d("debug", error)
Orchard.w("warning", error)
Orchard.e("error", error)
Orchard.f("fatal", error)

// message and arguments
let args = ["lorem" : "ipsum"]
Orchard.v("verbose", args)
Orchard.i("info", args)
Orchard.d("debug", args)
Orchard.w("warning", args)
Orchard.e("error", args)
Orchard.f("fatal", args)

// message, error and arguments
Orchard.v("verbose", error, args)
Orchard.i("info", error, args)
Orchard.d("debug", error, args)
Orchard.w("warning", error, args)
Orchard.e("error", error, args)
Orchard.f("fatal", error, args)
```

### Advanced Configuration

```swift
// Configure console logger
let consoleLogger = ConsoleLogger()
consoleLogger.showTimesStamp = true
consoleLogger.showInvocation = true
Orchard.loggers.append(consoleLogger)

// Add custom loggers
class MyCustomLogger: Orchard.Logger {
    // Implement logger methods
}
Orchard.loggers.append(MyCustomLogger())
```

## How to install

### Swift Package Manager

Add the dependency to your `Package.swift`

```swift
    products: [
      ...
    ]
    dependencies: [
        .package(url: "https://github.com/kibotu/Orchard", from: "1.0.2"),
    ],
    targets: [
      ...
    ]
```

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- Swift 5.10 or later

Contributions welcome!

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
