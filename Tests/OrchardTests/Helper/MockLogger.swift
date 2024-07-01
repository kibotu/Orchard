import XCTest
@testable import Orchard

class MockLogger: Orchard.Logger {
    var level: Orchard.Level = .verbose
    var tag: String?
    var icon: Character?
    
    var lastLogLevel: Orchard.Level?
    var lastMessage: String?
    var lastError: Error?
    var lastArgs: [String: CustomStringConvertible]?
    var lastTag: String?
    var lastIcon: Character?

    func log(_ level: Orchard.Level, _ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        lastLogLevel = level
        lastMessage = message
        lastError = error
        lastArgs = args
        lastTag = tag
        lastIcon = icon
    }

    func verbose(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.verbose, message, error, args, file, fileId, function, line)
    }

    func debug(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.debug, message, error, args, file, fileId, function, line)
    }

    func info(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.info, message, error, args, file, fileId, function, line)
    }

    func warning(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.warning, message, error, args, file, fileId, function, line)
    }

    func error(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.error, message, error, args, file, fileId, function, line)
    }

    func fatal(_ message: String?, _ error: Error?, _ args: [String: CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(.fatal, message, error, args, file, fileId, function, line)
    }
}
