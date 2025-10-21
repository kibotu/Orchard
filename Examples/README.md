# Orchard Examples

This directory contains example applications demonstrating the Orchard logging framework.

## 🍎 OrchardDemo - iOS App (Recommended)

**Location:** `Examples/OrchardDemo/`

A complete, ready-to-run iOS application with a visual interface.

### Quick Start

```bash
cd Examples/OrchardDemo
open OrchardDemo.xcodeproj
```

Then in Xcode:
1. Wait for package dependencies to resolve (~10 seconds)
2. Select any iOS Simulator (e.g., iPhone 16 Pro Max)
3. Press **⌘+R** to run

### Features

- ✅ **Ready to use** - Just open and run!
- ✅ **Visual interface** - See logs in real-time in the app
- ✅ **Interactive controls** - Create custom log messages
- ✅ **All features** - Tags, icons, levels, errors, arguments
- ✅ **Examples included** - "Run Examples" button shows everything
- ✅ **Console output** - Logs also appear in Xcode's console

[More details →](OrchardDemo/README.md)

## 📦 What's Included

### OrchardDemo/
Complete iOS app project with `.xcodeproj` file:
- SwiftUI interface
- Live log display
- Interactive controls
- All Orchard features demonstrated
- **Status:** ✅ Built and tested

## 🚀 Getting Started

The fastest way to see Orchard in action:

```bash
cd /Users/jan.rabe/Documents/repos/kibotu/Orchard/Examples/OrchardDemo
open OrchardDemo.xcodeproj
```

Press **⌘+R** in Xcode to run!

## 📱 What You'll See

The iOS demo app shows:
1. **Log Display** - Scrollable list of all logs with colors and icons
2. **Controls** - Create your own log messages with custom:
   - Log levels (Verbose → Fatal)
   - Tags (e.g., "Network", "Database")  
   - Icons (any emoji)
3. **Examples** - One-button demo of all features
4. **Live Updates** - Logs appear instantly as you create them

## 💡 Integration Examples

Each demo shows how to integrate Orchard into your projects:

```swift
import Orchard

// Setup
let logger = ConsoleLogger()
logger.showTimesStamp = true
logger.showInvocation = true
Orchard.loggers.append(logger)

// Use anywhere
Orchard.i("Info message")
Orchard.tag("Network").d("Request completed")
Orchard.icon("🚀").i("App launched")
```

## 🛠 Requirements

- Xcode 15.0 or later
- iOS 16.0 or later
- Swift 5.10 or later
- macOS for Xcode

## 📝 Notes

- All examples use **local package dependencies** to the Orchard library
- Changes to Orchard are immediately reflected in the demos
- The iOS app keeps only the last 50 logs to avoid memory issues
- All logs also appear in Xcode's console

---

**Ready to try it?** → Open `OrchardDemo/OrchardDemo.xcodeproj` and press ⌘+R!

