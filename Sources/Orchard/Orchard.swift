import Foundation

/// Orchard: A versatile and unified logging system for Swift applications
///
/// The `Orchard` class provides a centralized logging mechanism that allows for easy integration
/// of multiple logging backends while offering a clean and consistent API for logging across
/// your entire application.
///
/// # Key Features:
/// - Support for multiple logging levels (verbose, debug, info, warning, error, fatal)
/// - Ability to add custom loggers
/// - Chainable methods for setting tags and icons
/// - Automatic capture of file, function, and line information
///
/// # Usage:
/// ```
/// // Add your custom loggers
/// Orchard.loggers.append(MyCustomLogger())
///
/// // Basic logging
/// Orchard.i("User logged in successfully")
///
/// // Logging with additional context
/// Orchard.tag("NetworkManager").icon("🌐").e("Failed to fetch data", error)
/// ```
///
/// # Best Practices:
/// 1. Use appropriate log levels for different scenarios
/// 2. Utilize tags to categorize logs (e.g., by module or feature)
/// 3. Include relevant context in your log messages
/// 4. Be mindful of performance impact in production environments
///
/// Remember: Logging is a powerful tool for debugging and monitoring, but it should be used
/// judiciously to avoid cluttering your logs or impacting performance.
public class Orchard {
    
    /// Array of loggers that will receive log messages
    static var loggers = [Orchard.Logger]()
    
    /// Current tag to be applied to the next log message
    static  private var _tag: String?
    static private let lock = NSLock()

    static private var tag: String? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _tag
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _tag = newValue
        }
    }
    
    /// Current icon to be applied to the next log message
    private static var _icon: Character?
    private static let iconLock = NSLock()

    private static var icon: Character? {
        get {
            iconLock.lock()
            defer { iconLock.unlock() }
            return _icon
        }
        set {
            iconLock.lock()
            defer { iconLock.unlock() }
            _icon = newValue
        }
    }
    
    /// Sets a tag for the next log message
    ///
    /// - Parameter tag: A string to categorize the log message
    /// - Returns: The Orchard type for method chaining
    @discardableResult
    static func tag(_ tag: String) -> Orchard.Type {
        self.tag = tag
        return self
    }
    
    /// Sets an icon for the next log message
    ///
    /// - Parameter icon: A character to visually represent the log message
    /// - Returns: The Orchard type for method chaining
    @discardableResult
    static func icon(_ icon: Character?) -> Orchard.Type {
        self.icon = icon
        return self
    }
    
    // MARK: - Logging Methods
    
    /// Logs a verbose message
    ///
    /// Use this for highly detailed information, typically only valuable during debugging
    public static func v(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .verbose, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a debug message
    ///
    /// Use this for information that is useful during development but not needed in production
    public static func d(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .debug, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an info message
    ///
    /// Use this for general information about the application's operation
    public static func i(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .info, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a warning message
    ///
    /// Use this for potentially harmful situations that don't cause immediate issues
    public static func w(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .warning, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an error message
    ///
    /// Use this for error conditions that might still allow the application to continue running
    public static func e(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .error, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a fatal message
    ///
    /// Use this for severe error conditions that will likely lead to application failure
    public static func f(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log(level: .fatal, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    // MARK: - Private Helper Method
    
    private static func log(level: Level, message: String?, error: Error?, args: [String: CustomStringConvertible]?, file: String, fileId: String, function: String, line: Int) {
        for var logger in loggers {
            logger.tag = tag
            logger.icon = icon
            switch level {
            case .verbose: logger.verbose(message, error, args, file, fileId, function, line)
            case .debug: logger.debug(message, error, args, file, fileId, function, line)
            case .info: logger.info(message, error, args, file, fileId, function, line)
            case .warning: logger.warning(message, error, args, file, fileId, function, line)
            case .error: logger.error(message, error, args, file, fileId, function, line)
            case .fatal: logger.fatal(message, error, args, file, fileId, function, line)
            }
        }
        tag = nil
        icon = nil
    }
    
    /// Represents different severity levels for log messages
    public enum Level: String, Codable, Comparable {
        /// Detailed information, typically useful for debugging
        case verbose
        /// Information useful during development, not intended for production
        case debug
        /// General information about the application's operation (e.g. Breadcrumbs)
        case info
        /// Potentially harmful situations that don't cause immediate issues
        case warning
        /// Error conditions that might still allow the application to continue running
        case error
        /// Severe error conditions that will likely lead to application failure
        case fatal
        
        /// Returns a human-readable string representation of the log level
        var displayValue: String {
            switch self {
            case .verbose: return "Verbose"
            case .debug: return "Debug"
            case .info: return "Info"
            case .warning: return "Warning"
            case .error: return "Error"
            case .fatal: return "Critical"
            }
        }
        
        /// Returns an icon character representing the log level
        var icon: Character {
            switch self {
            case .verbose: return "🔬"
            case .debug: return "🔍"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .fatal: return "⚡️"
            }
        }
        
        /// Internal representation of severity order for comparison
        private var severityOrder: Int {
            switch self {
            case .verbose: return 0
            case .debug: return 1
            case .info: return 2
            case .warning: return 3
            case .error: return 4
            case .fatal: return 5
            }
        }
        
        /// Compares two log levels based on their severity
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side log level
        ///   - rhs: The right-hand side log level
        /// - Returns: true if the left-hand side is less severe than the right-hand side
        public static func < (lhs: Level, rhs: Level) -> Bool {
            lhs.severityOrder < rhs.severityOrder
        }
        
        public static func printStackTrace() {
            Thread.printStackTrace()
        }
        
        public static var callStack: [String] {
            return Thread.callStack
        }
    }
    
    /// Protocol defining the interface for custom loggers
    ///
    /// Implement this protocol to create your own logger that can be added to Orchard
    public protocol Logger {
        /// The minimum log level this logger will process
        var level: Level { get }
        
        /// Optional tag to categorize log messages
        var tag: String? { get set }
        
        /// Optional icon to visually represent log messages
        var icon: Character? { get set }
        
        /// Log a verbose message
        /// - Parameters:
        ///   - message: The main log message
        ///   - error: An optional error associated with the log
        ///   - args: Additional key-value pairs for context
        ///   - file: The file where the log was called (automatically captured)
        ///   - fileId: The file ID where the log was called (automatically captured)
        ///   - function: The function where the log was called (automatically captured)
        ///   - line: The line number where the log was called (automatically captured)
        func verbose(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
        
        /// Log a debug message
        func debug(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
        
        /// Log an info message
        func info(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
        
        /// Log a warning message
        func warning(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
        
        /// Log an error message
        func error(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
        
        /// Log a fatal message
        func fatal(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int)
    }
}
