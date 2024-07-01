import XCTest
@testable import Orchard

class ConsoleLoggerTests: XCTestCase {

    var consoleLogger: ConsoleLogger!
    var outputCapture: OutputCapture!

    override func setUp() {
        super.setUp()
        consoleLogger = ConsoleLogger()
        outputCapture = OutputCapture()
    }

    override func tearDown() {
        consoleLogger = nil
        outputCapture = nil
        super.tearDown()
    }

    func testVerboseLogging() {
        outputCapture.startCapture()
        consoleLogger.verbose("Verbose test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("🔬"))
        XCTAssertTrue(output.contains("Verbose test"))
    }

    func testDebugLogging() {
        outputCapture.startCapture()
        consoleLogger.debug("Debug test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("🔍"))
        XCTAssertTrue(output.contains("Debug test"))
    }

    func testInfoLogging() {
        outputCapture.startCapture()
        consoleLogger.info("Info test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("ℹ️"))
        XCTAssertTrue(output.contains("Info test"))
    }

    func testWarningLogging() {
        outputCapture.startCapture()
        consoleLogger.warning("Warning test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("⚠️"))
        XCTAssertTrue(output.contains("Warning test"))
    }

    func testErrorLogging() {
        outputCapture.startCapture()
        consoleLogger.error("Error test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("❌"))
        XCTAssertTrue(output.contains("Error test"))
    }

    func testFatalLogging() {
        outputCapture.startCapture()
        consoleLogger.fatal("Fatal test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("⚡️"))
        XCTAssertTrue(output.contains("Fatal test"))
    }

    func testLoggingWithTimestamp() {
        consoleLogger.showTimesStamp = true
        outputCapture.startCapture()
        consoleLogger.info("Timestamp test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
    }

    func testLoggingWithoutTimestamp() {
        consoleLogger.showTimesStamp = false
        outputCapture.startCapture()
        consoleLogger.info("No timestamp test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertFalse(output.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
    }

    func testLoggingWithInvocation() {
        consoleLogger.showInvocation = true
        outputCapture.startCapture()
        consoleLogger.info("Invocation test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertTrue(output.contains("/ConsoleLoggerTests.testLoggingWithInvocation"))
    }

    func testLoggingWithoutInvocation() {
        consoleLogger.showInvocation = false
        outputCapture.startCapture()
        consoleLogger.info("No invocation test", nil, nil, #file, #fileID, #function, #line)
        let output = outputCapture.stopCapture()
        XCTAssertFalse(output.contains("/ConsoleLoggerTests.testLoggingWithoutInvocation"))
    }
}
