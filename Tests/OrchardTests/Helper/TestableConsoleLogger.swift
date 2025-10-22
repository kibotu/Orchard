import XCTest
@testable import Orchard

class TestableConsoleLogger: ConsoleLogger {
    var lastLoggedMessage: String = ""

    override func log(level: Orchard.Level, message: String?, error: (any Error)?, args: [String : any CustomStringConvertible]?, file: String, fileId: String, function: String, line: Int) {
        let functionName = function.components(separatedBy: "(").first ?? function
        let invocation = showInvocation ? "/\(fileId.fileFromfileId).\(functionName):\(line)" : ""
        lastLoggedMessage = "\(icon ?? level.icon) \(date)[\(tag ?? file.moduleNameFromFile)\(invocation)]\(message.paddedNilOrValue)\(error.paddedNilOrValue)\(paddedToString(args))"
        tag = nil
        icon = nil
    }
}
