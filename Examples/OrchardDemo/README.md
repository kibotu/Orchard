# Orchard iOS Demo App

A complete, ready-to-run iOS app demonstrating the Orchard logging framework.

## 🚀 Quick Start

### Open in Xcode

```bash
cd /Users/jan.rabe/Documents/repos/kibotu/Orchard/Examples/OrchardDemo
open OrchardDemo.xcodeproj
```

Or double-click `OrchardDemo.xcodeproj` in Finder.

### Run the App

1. Wait for Xcode to resolve package dependencies (automatic, takes ~10 seconds)
2. Select an iOS Simulator (e.g., iPhone 15)
3. Press **⌘+R** to build and run
4. The app will launch in the simulator

## ✨ Features

The demo app showcases all of Orchard's features:

### Interactive UI
- **Custom Log Messages**: Type your own messages
- **Log Levels**: Choose from Verbose, Debug, Info, Warning, Error, Fatal
- **Tags**: Add custom tags to categorize logs
- **Icons**: Use custom emoji icons
- **Live Display**: See logs appear in real-time in the app
- **Console Output**: All logs also appear in Xcode's console

### Examples Button
Click "Run Examples" to see:
- All log levels in action
- Tagged logs (Network, Database, Auth, etc.)
- Custom icons (🚀, 💾, 🌐, etc.)
- Tags + icons combined
- Error logging
- Logs with additional context (key-value arguments)

## 📱 What You'll See

The app has two main sections:

1. **Log Display (top)**: 
   - Shows all logs in reverse chronological order
   - Color-coded by level
   - Shows tags, icons, and timestamps
   - Scrollable list

2. **Controls (bottom)**:
   - Message input field
   - Log level selector (segmented control)
   - Tag toggle and input
   - Icon toggle and input
   - Action buttons (Log, Run Examples, Clear)

## 🛠 How It Works

The app demonstrates Orchard's key features:

```swift
// Setup (done in ContentView.onAppear)
let consoleLogger = ConsoleLogger()
consoleLogger.showTimesStamp = true
consoleLogger.showInvocation = true
Orchard.loggers.append(consoleLogger)

// Basic logging
Orchard.i("Info message")
Orchard.e("Error message")

// With tags
Orchard.tag("Network").d("Request completed")

// With icons
Orchard.icon("🚀").i("App launched")

// With tags + icons
Orchard.tag("Payment").icon("💳").i("Payment processed")

// With errors
Orchard.e("Failed", someError)

// With additional context
Orchard.i("User logged in", ["userId": "12345"])
```

## 📋 Requirements

- Xcode 15.0 or later
- iOS 16.0 or later (Simulator or Device)
- Swift 5.10 or later

## 🔗 Integration

This app uses a **local package dependency** to the Orchard framework:
- The project references `../../` (the root Orchard package)
- Xcode automatically resolves this dependency
- Any changes to Orchard will be reflected immediately

## 🎯 Use This As a Template

Feel free to use this app as a starting point for integrating Orchard into your own projects:

1. Copy the `UILogger` class for in-app log display
2. See how to setup Orchard in `setupOrchard()`
3. Use the logging examples as a reference

## 🐛 Troubleshooting

### Dependencies Not Resolving
- Make sure you're in the correct directory
- Try: File → Packages → Resolve Package Versions in Xcode

### Build Errors
- Clean build folder: ⇧⌘+K
- Rebuild: ⌘+B

### Can't Run on Simulator
- Make sure you have an iOS 16.0+ simulator installed
- Xcode → Settings → Platforms → iOS Simulators

## 📝 Notes

- The app keeps only the last 50 logs to avoid memory issues
- All logs also appear in Xcode's console (⇧⌘+C to show)
- The console logger shows file/function/line information
- Colors and icons make it easy to spot different log levels

Enjoy using Orchard! 🍎🌳

