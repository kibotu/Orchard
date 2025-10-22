import Foundation

/// A concrete implementation of Orchard.Logger that logs messages to the console
public class ConsoleLogger: Orchard.Logger {
    
    /// Configuration for logger behavior and formatting
    public var config: ConsoleLoggerConfig {
        didSet {
            // Update formatter when config changes
            formatter.dateFormat = config.timestampFormat
        }
    }
    
    /// Public initializer for ConsoleLogger
    /// - Parameter config: Optional configuration (defaults to ConsoleLoggerConfig.default)
    public init(config: ConsoleLoggerConfig = .default) {
        self.config = config
        self.formatter = DateFormatter()
        self.formatter.dateFormat = config.timestampFormat
    }
    
    /// Convenience initializer with configuration closure
    /// - Parameter configure: A closure that receives an inout ConsoleLoggerConfig to configure
    ///
    /// Example:
    /// ```swift
    /// let logger = ConsoleLogger { config in
    ///     config.showTimestamp = true
    ///     config.timestampFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    ///     config.showInvocation = true
    ///     config.moduleNameMapper = { module in
    ///         return module.replacingOccurrences(of: "OrchardDemo", with: "Demo")
    ///     }
    /// }
    /// ```
    public convenience init(configure: (inout ConsoleLoggerConfig) -> Void) {
        var config = ConsoleLoggerConfig.default
        configure(&config)
        self.init(config: config)
    }
    
    /// The minimum log level this logger will process (set to verbose by default)
    public let level: Orchard.Level = Orchard.Level.verbose
        
    /// Optional tag to categorize log messages
    nonisolated(unsafe) private var _tag: String?
    private let lock = NSLock()

    public var tag: String? {
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
    
    /// Optional icon to visually represent log messages
    nonisolated(unsafe) private var _icon: Character?
    private let iconLock = NSLock()

    public var icon: Character? {
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
    
    /// Determines whether to show timestamps in log messages
    /// Forwards to config.showTimestamp for backward compatibility
    public var showTimesStamp: Bool {
        get { config.showTimestamp }
        set { config.showTimestamp = newValue }
    }
    
    /// Determines whether to show invocation details (file, function, line) in log messages
    /// Forwards to config.showInvocation for backward compatibility
    public var showInvocation: Bool {
        get { config.showInvocation }
        set { config.showInvocation = newValue }
    }
    
    /// Date formatter for timestamp formatting
    private var formatter: DateFormatter
    
    /// Computed property that returns a formatted timestamp string if showTimestamp is true, otherwise an empty string
    var date: String {
        if config.showTimestamp {
            "\(formatter.string(from: Date())): "
        } else {
            ""
        }
    }
    
    /// Logs a verbose message to the console
    /// - Parameters:
    ///   - message: The main log message
    ///   - error: An associated error, if any
    ///   - args: Additional context as key-value pairs
    ///   - file: The file where the log was called
    ///   - fileId: The file ID where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line number where the log was called
    public func verbose(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.verbose else { return }
        log(level: .verbose, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a debug message to the console
    public func debug(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.debug else { return }
        log(level: .debug, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an info message to the console
    public func info(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.info else { return }
        log(level: .info, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a warning message to the console
    public func warning(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.warning else { return }
        log(level: .warning, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an error message to the console
    public func error(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.error else { return }
        log(level: .error, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a fatal message to the console
    public func fatal(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.fatal else { return }
        log(level: .fatal, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Private helper method to format and print log messages
    /// - Parameters:
    ///   - level: The log level
    ///   - message: The main log message
    ///   - error: An associated error, if any
    ///   - args: Additional context as key-value pairs
    ///   - file: The file where the log was called
    ///   - fileId: The file ID where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line number where the log was called
    open func log(level: Orchard.Level, message: String?, error: (any Error)?, args: [String : any CustomStringConvertible]?, file: String, fileId: String, function: String, line: Int) {
        let functionName = function.components(separatedBy: "(").first ?? function
        let invocation = config.showInvocation ? "/\(fileId.fileFromfileId).\(functionName):\(line)" : ""
        
        // Apply module name mapper if provided, otherwise use default
        let moduleName: String
        if let mapper = config.moduleNameMapper {
            moduleName = mapper(fileId.moduleNameFromFile)
        } else {
            moduleName = fileId.moduleNameFromFile
        }
        
        print("\(icon ?? level.icon) \(date)[\(tag ?? moduleName)\(invocation)]\(message.paddedNilOrValue)\(error.paddedNilOrValue)\(paddedToString(args))")
        tag = nil
        icon = nil
    }
}
