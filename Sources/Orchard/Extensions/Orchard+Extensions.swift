import Foundation

public extension Orchard {
    // MARK: - Convenience methods for logging errors without messages
    
    /// Logs a verbose message with an error and optional arguments
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
    
    // MARK: - Convenience methods for logging messages with arguments without errors
    
    /// Logs a verbose message with optional arguments
    static func v(_ message: String? = nil, _ args: [String: CustomStringConvertible]? = nil, _ file: String = #file, _ fileId: String = #fileID, _ function: String = #function, _ line: Int = #line) {
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

extension Optional where Wrapped == Error {
    var paddedNilOrValue: String {
        switch self {
        case .some(let value):
            return " \(value)"

        case .none:
            return ""
        }
    }
}

func paddedToString(_ args: [String: any CustomStringConvertible]?, _ opt: JSONSerialization.WritingOptions = [.sortedKeys]) -> String {
    guard let args = args else {
        return ""
    }
    
    // JSONSerialization raises an Objective-C exception (uncatchable from Swift) for values it cannot
    // encode, so anything that is not valid JSON falls back to its description.
    let jsonObject = args.mapValues { value -> Any in
        JSONSerialization.isValidJSONObject([value]) ? value : value.description
    }

    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: opt),
          let jsonString = String(data: jsonData, encoding: .utf8) else {
        return ""
    }
    return " \(jsonString)"
}

extension Optional where Wrapped == String {
    var paddedNilOrValue: String {
        switch self {
        case .some(let value):
            return " \(value)"

        case .none:
            return ""
        }
    }
}
