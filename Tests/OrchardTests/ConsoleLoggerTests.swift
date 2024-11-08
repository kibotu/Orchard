import XCTest
@testable import Orchard

class ConsoleLoggerTests: XCTestCase {

    var consoleLogger: TestableConsoleLogger!

    override func setUp() {
        super.setUp()
        consoleLogger = TestableConsoleLogger()
    }

    override func tearDown() {
        consoleLogger = nil
        super.tearDown()
    }

    func testVerboseLogging() {
        consoleLogger.verbose("Verbose test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("🔬"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Verbose test"))
    }

    func testDebugLogging() {
        consoleLogger.debug("Debug test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("🔍"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Debug test"))
    }

    func testInfoLogging() {
        consoleLogger.info("Info test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("ℹ️"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Info test"))
    }

    func testWarningLogging() {
        consoleLogger.warning("Warning test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("⚠️"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Warning test"))
    }

    func testErrorLogging() {
        consoleLogger.error("Error test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("❌"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Error test"))
    }

    func testFatalLogging() {
        consoleLogger.fatal("Fatal test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("⚡️"))
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("Fatal test"))
    }

    func testLoggingWithTimestamp() {
        consoleLogger.showTimesStamp = true
        consoleLogger.info("Timestamp test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
    }

    func testLoggingWithoutTimestamp() {
        consoleLogger.showTimesStamp = false
        consoleLogger.info("No timestamp test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertFalse(consoleLogger.lastLoggedMessage.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
    }

    func testLoggingWithInvocation() {
        consoleLogger.showInvocation = true
        consoleLogger.info("Invocation test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("/ConsoleLoggerTests.testLoggingWithInvocation"))
    }

    func testLoggingWithoutInvocation() {
        consoleLogger.showInvocation = false
        consoleLogger.info("No invocation test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertFalse(consoleLogger.lastLoggedMessage.contains("/ConsoleLoggerTests.testLoggingWithoutInvocation"))
    }
}
