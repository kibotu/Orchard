import Foundation

/// A concrete implementation of Orchard.Logger that logs messages to the console
public class ConsoleLogger: Orchard.Logger {
    
    /// The minimum log level this logger will process (set to verbose by default)
    let level: Orchard.Level = Orchard.Level.verbose
        
    /// Optional tag to categorize log messages
    private var _tag: String?
    private let lock = NSLock()

    var tag: String? {
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
    private var _icon: Character?
    private let iconLock = NSLock()

    var icon: Character? {
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
    /// Persisted using @Storage property wrapper with key "ConsoleLogger_Log_Timestamp"
    var showTimesStamp: Bool = true
    
    /// Determines whether to show invocation details (file, function, line) in log messages
    /// Persisted using @Storage property wrapper with key "ConsoleLogger_Log_Invocation"
    var showInvocation: Bool = true
    
    /// Lazy-initialized date formatter for timestamp formatting
    private lazy var formatter = DateFormatter().apply {
        $0.dateFormat = "HH:mm:ss.SSS"
    }
    
    /// Computed property that returns a formatted timestamp string if showTimesStamp is true, otherwise an empty string
    var date: String {
        if showTimesStamp {
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
    func verbose(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.verbose else { return }
        log(level: .verbose, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a debug message to the console
    func debug(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.debug else { return }
        log(level: .debug, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an info message to the console
    func info(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.info else { return }
        log(level: .info, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a warning message to the console
    func warning(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.warning else { return }
        log(level: .warning, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs an error message to the console
    func error(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        guard level <= Orchard.Level.error else { return }
        log(level: .error, message: message, error: error, args: args, file: file, fileId: fileId, function: function, line: line)
    }
    
    /// Logs a fatal message to the console
    func fatal(_ message: String?, _ error: (any Error)?, _ args: [String : any CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
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
        let invocation = showInvocation ? "/\(fileId.fileFromfileId).\(function):\(line)" : ""
        print("\(icon ?? level.icon) \(date)[\(tag ?? file.moduleNameFromFile)\(invocation)]\(message.paddedNilOrValue)\(error.paddedNilOrValue)\(paddedToString(args))")
        tag = nil
        icon = nil
    }
}
