# Orchard vs Other iOS Logging Solutions

A practical comparison of logging frameworks for iOS development.

## Quick Comparison Table

| Feature | Orchard | OSLog | Logger API | CocoaLumberjack |
|---------|---------|-------|------------|-----------------|
| **Automatic File/Function/Line** | ✅ Clean, readable | ✅ Native | ✅ Native | ✅ Via macros |
| **Flexible Parameters** | ✅ Message, Error, Args in any combo | ⚠️ String interpolation only | ⚠️ String interpolation only | ⚠️ String only |
| **Multiple Destinations** | ✅ Easy append | ⚠️ Console.app, Instruments | ⚠️ Console.app, Instruments | ✅ Multiple appenders |
| **Tags/Categories** | ✅ Dynamic per-call | ✅ Per-logger subsystem | ✅ Per-logger category | ✅ Context objects |
| **Custom Icons** | ✅ Per-call | ❌ | ❌ | ❌ |
| **Structured Arguments** | ✅ Dictionary support | ⚠️ Limited | ⚠️ Limited | ❌ String only |
| **Swift 6 Ready** | ✅ | ✅ | ✅ | ⚠️ Obj-C based |
| **Zero Dependencies** | ✅ Pure Swift | ✅ Built-in | ✅ Built-in | ❌ External |
| **Learning Curve** | Low | Medium | Low | High |
| **Performance** | Good | Excellent | Excellent | Good |
| **Privacy Controls** | Manual | ✅ Built-in | ✅ Built-in | Manual |
| **Production Ready** | ✅ | ✅ | ✅ | ✅ |
| **Compile-Time Optimization** | ❌ | ✅ | ✅ | ⚠️ Partial |

## Detailed Comparison

### OSLog (Legacy)

Apple's unified logging system introduced in iOS 10.

**Pros:**
- Native system integration with Console.app and Instruments
- Excellent performance with compile-time optimization
- Privacy controls (`%{private}s`, `%{public}s`)
- Zero-cost when log level disabled
- Subsystem and category organization

**Cons:**
- Complex format string syntax: `os_log("%{public}s failed: %{public}s", log: logger, type: .error, message, error)`
- Categories/subsystems defined at logger creation, not per-call
- Primarily designed for Apple's diagnostic tools, not custom destinations
- Harder to send logs to third-party services
- C-style format strings feel dated in Swift

**Example:**
```swift
import os.log

let logger = OSLog(subsystem: "com.example.app", category: "network")
os_log("User logged in: %{public}s", log: logger, type: .info, userId)
```

---

### Logger API (Swift)

Apple's modern Swift-native logging API (iOS 14+).

**Pros:**
- Clean Swift syntax with string interpolation
- Privacy by default (automatic redaction)
- Integration with Console.app and Instruments
- Type-safe with compile-time optimization
- Subsystem and category organization

**Cons:**
- Categories/subsystems still defined at logger creation
- Limited to Apple's logging infrastructure
- Can't easily send to custom destinations (files, remote servers, crash reporters)
- No built-in structured metadata support
- String interpolation only—no separate error or arguments handling

**Example:**
```swift
import OSLog

let logger = Logger(subsystem: "com.example.app", category: "network")
logger.info("User logged in: \(userId)")
logger.error("Request failed: \(error)")
```

---

### CocoaLumberjack

Battle-tested, mature logging framework (Objective-C based).

**Pros:**
- Extremely flexible with multiple appenders (console, file, database, remote)
- Fine-grained log level control per logger
- File rotation and archival built-in
- Proven in production for 10+ years
- Extensive configuration options

**Cons:**
- Objective-C heritage (bridging overhead, less Swift-friendly)
- Verbose macro-based API: `DDLogInfo(@"User logged in")`
- String-only logging (no structured arguments)
- Larger dependency footprint
- Steeper learning curve with many configuration options
- Active development has slowed

**Example:**
```objc
// Objective-C style
DDLogInfo(@"User logged in: %@", userId);

// Swift
DDLogInfo("Request failed: \(error.localizedDescription)")
```

---

### Orchard

Modern Swift logging with flexible parameters and dynamic tagging.

**Pros:**
- Flexible API: any combination of message, error, and structured arguments
- Dynamic tags and icons per log call (not per logger)
- Easy multi-destination logging (console, file, remote, crash reporters)
- Clean, readable invocation tracking without manual maintenance
- Pure Swift, zero external dependencies
- Low learning curve
- Great for teams needing custom logging destinations

**Cons:**
- Slight runtime overhead (not compile-time optimized like OSLog)
- No built-in privacy controls
- Smaller community compared to OSLog/CocoaLumberjack
- Manual log level filtering required for release builds
- String-based tags (not type-safe)

**Example:**
```swift
import Orchard

Orchard.tag("Network").icon("🌐").e("Request failed", error, ["url": url, "status": code])
```

---

## When to Use Each

### Use **OSLog/Logger** when:
- Building apps primarily for Apple ecosystem diagnostics
- Performance is absolutely critical
- Privacy controls are required by default
- You want compile-time optimization
- Using Console.app and Instruments extensively

### Use **CocoaLumberjack** when:
- Working with legacy codebases (Objective-C)
- Need battle-tested file rotation and management
- Require extensive configuration options
- Already invested in DDLog ecosystem

### Use **Orchard** when:
- Need logs in multiple custom destinations (files, remote servers, crash reporters)
- Want flexible logging API (message + error + structured data)
- Prefer dynamic categorization per log call (tags)
- Building Swift-first applications
- Need readable invocation tracking without manual maintenance
- Want simple, clean API with low learning curve
- Team needs to implement custom loggers

---

## Hybrid Approach

You can combine solutions:

```swift
// OSLog for Apple diagnostics
let osLogger = Logger(subsystem: "com.example.app", category: "network")
osLogger.info("Request started")

// Orchard for custom destinations
Orchard.loggers.append(ConsoleLogger())
Orchard.loggers.append(FileLogger())
Orchard.loggers.append(CrashlyticsLogger())
Orchard.tag("Network").i("Request started", ["endpoint": url])
```

Or create an Orchard logger that bridges to OSLog:

```swift
class OSLogBridge: Orchard.Logger {
    let level: Orchard.Level = .verbose
    var tag: String?
    var icon: Character?
    
    private let osLogger: Logger
    
    init(subsystem: String, category: String) {
        self.osLogger = Logger(subsystem: subsystem, category: category)
    }
    
    func info(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, 
              _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        osLogger.info("\(message ?? "") \(error?.localizedDescription ?? "")")
    }
    // Implement other levels...
}
```

---

## Performance Considerations

- **OSLog/Logger**: Near-zero cost for disabled levels (compile-time optimization)
- **Orchard**: Runtime overhead for capturing invocation info (negligible in most cases)
- **CocoaLumberjack**: Good performance, but Objective-C bridging adds overhead

For high-frequency logging (tight loops, hot paths), consider:
1. Conditional compilation for release builds
2. Log level filtering at the logger level
3. Lazy evaluation of expensive operations

---

## Conclusion

No single solution fits all use cases. Choose based on your needs:

- **Native diagnostics**: OSLog/Logger
- **Custom destinations & flexibility**: Orchard
- **Legacy support & file management**: CocoaLumberjack
- **Hybrid**: Use multiple solutions where they excel

Orchard's strength is its **flexibility** and **ease of use** for teams that need custom logging infrastructure beyond Apple's built-in tools.

