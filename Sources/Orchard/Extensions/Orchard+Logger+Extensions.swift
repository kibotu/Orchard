public extension Orchard.Logger {
    
    /// Logs a verbose message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func v(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        verbose(message, error, args, file, fileId, function, line)
    }
    
    /// Logs a debug message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func d(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        debug(message, error, args, file, fileId, function, line)
    }
    
    /// Logs an info message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func i(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        info(message, error, args, file, fileId, function, line)
    }
    
    /// Logs a warning message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func w(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        warning(message, error, args, file, fileId, function, line)
    }
    
    /// Logs an error message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func e(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        self.error(message, error, args, file, fileId, function, line)
    }
    
    /// Logs a fatal message with optional error and additional context
    /// - Parameters:
    ///   - message: The main log message (optional)
    ///   - error: An associated error, if any (optional)
    ///   - args: Additional context as key-value pairs (optional)
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    func f(_ message: String? = nil, _ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        fatal(message, error, args, file, fileId, function, line)
    }
}
