# Orchard Demo

Interactive iOS app demonstrating the Orchard logging framework.

## Run

```bash
cd Examples/OrchardDemo
open OrchardDemo.xcodeproj
```

Press **⌘+R** in Xcode.

## Features

- All log levels (Verbose → Fatal)
- Tags and custom icons
- Live in-app display
- Interactive controls
- "Run Examples" button

## Setup

```swift
import Orchard

let logger = ConsoleLogger()
logger.showTimesStamp = true
Orchard.loggers.append(logger)

Orchard.i("Info message")
Orchard.tag("Network").d("Request completed")
Orchard.icon("🚀").i("App launched")
```

## Requirements

- Xcode 15.0+
- iOS 16.0+

