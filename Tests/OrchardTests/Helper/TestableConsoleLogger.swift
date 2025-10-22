import XCTest
@testable import Orchard

class TestableConsoleLogger: ConsoleLogger {
    var lastLoggedMessage: String = ""

    override func log(level: Orchard.Level, message: String?, error: (any Error)?, args: [String : any CustomStringConvertible]?, file: String, fileId: String, function: String, line: Int) {
        let functionName = function.components(separatedBy: "(").first ?? function
        let invocation = config.showInvocation ? "/\(fileId.fileFromfileId).\(functionName):\(line)" : ""
        
        // Apply module name mapper if provided, otherwise use default
        let moduleName: String
        if let mapper = config.moduleNameMapper {
            moduleName = mapper(fileId.moduleNameFromFile)
        } else {
            moduleName = fileId.moduleNameFromFile
        }
        
        lastLoggedMessage = "\(icon ?? level.icon) \(date)[\(tag ?? moduleName)\(invocation)]\(message.paddedNilOrValue)\(error.paddedNilOrValue)\(paddedToString(args))"
        tag = nil
        icon = nil
    }
}
