import Foundation

public extension Orchard {
    
    /// MARK: - Convenience methods for logging errors without messages
    
    /// Logs a verbose message with an error and optional arguments
    /// - Parameters:
    ///   - error: The error to log
    ///   - args: Additional context as key-value pairs
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    static func v(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        v(nil, error, args, file, fileId, function, line)
    }
    
    /// Logs a debug message with an error and optional arguments
    static func d(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        d(nil, error, args, file, fileId, function, line)
    }
    
    /// Logs an info message with an error and optional arguments
    static func i(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        i(nil, error, args, file, fileId, function, line)
    }
    
    /// Logs a warning message with an error and optional arguments
    static func w(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        w(nil, error, args, file, fileId, function, line)
    }
    
    /// Logs an error message with an error and optional arguments
    static func e(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        e(nil, error, args, file, fileId, function, line)
    }
    
    /// Logs a fatal message with an error and optional arguments
    static func f(_ error: Error? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        f(nil, error, args, file, fileId, function, line)
    }
    
    /// MARK: - Convenience methods for logging messages with arguments without errors
    
    /// Logs a verbose message with optional arguments
    /// - Parameters:
    ///   - message: The message to log
    ///   - args: Additional context as key-value pairs
    ///   - file: The file where the log was called (default: #file)
    ///   - fileId: The file ID where the log was called (default: #fileID)
    ///   - function: The function where the log was called (default: #function)
    ///   - line: The line number where the log was called (default: #line)
    static func v(_ message: String? = nil,  _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        v(message, nil, args, file, fileId, function, line)
    }
    
    /// Logs a debug message with optional arguments
    static func d(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        d(message, nil, args, file, fileId, function, line)
    }
    
    /// Logs an info message with optional arguments
    static func i(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        i(message, nil, args, file, fileId, function, line)
    }
    
    /// Logs a warning message with optional arguments
    static func w(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        w(message, nil, args, file, fileId, function, line)
    }
    
    /// Logs an error message with optional arguments
    static func e(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        e(message, nil, args, file, fileId, function, line)
    }
    
    /// Logs a fatal message with optional arguments
    static func f(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        f(message, nil, args, file, fileId, function, line)
    }
}

/// Extension to provide a padded string representation of an optional Error
extension Optional where Wrapped == Error {
    
    /// Returns a padded string representation of the error
    /// - Returns: A string with a leading space and the error description if present, or an empty string if nil
    var paddedNilOrValue: String {
        switch self {
        case .some(let value):
            return " \(value)"
        case .none:
            return ""
        }
    }
}

/// Converts a dictionary of CustomStringConvertible values to a JSON string
/// - Parameters:
///   - args: The dictionary to convert
///   - opt: JSON writing options (default: [.sortedKeys])
/// - Returns: A padded JSON string representation of the dictionary, or an empty string if conversion fails
func paddedToString(_ args: [String: any CustomStringConvertible]?, _ opt: JSONSerialization.WritingOptions = [.sortedKeys]) -> String {
    guard let args = args else {
        return ""
    }
    
    let encoder = JSONEncoder()
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: args, options: opt)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return " \(jsonString)"
        }
    } catch {
        // ignore
    }
    
    return ""
}

/// Extension to provide a padded string representation of an optional String
extension Optional where Wrapped == String {
    /// Returns a padded string representation of the optional String
    /// - Returns: A string with a leading space and the value if present, or an empty string if nil
    var paddedNilOrValue: String {
        switch self {
        case .some(let value):
            return " \(value)"
        case .none:
            return ""
        }
    }
}
