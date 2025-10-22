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
    
    func testFunctionSignatureIsStripped() {
        consoleLogger.showInvocation = true
        consoleLogger.info("Signature test", nil, nil, #file, #fileID, #function, #line)
        // Should contain function name without parentheses
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("/ConsoleLoggerTests.testFunctionSignatureIsStripped:"))
        // Should NOT contain parentheses from function signature
        XCTAssertFalse(consoleLogger.lastLoggedMessage.contains("testFunctionSignatureIsStripped()"))
    }
    
    func testFunctionWithParametersIsStripped() {
        consoleLogger.showInvocation = true
        // Simulate a function with parameters by passing a custom function string
        let functionName = "log(_:_:)"
        consoleLogger.log(level: .info, message: "Parameter test", error: nil, args: nil, file: #file, fileId: #fileID, function: functionName, line: #line)
        // Should contain only the base function name
        XCTAssertTrue(consoleLogger.lastLoggedMessage.contains("/ConsoleLoggerTests.log:"))
        // Should NOT contain the parameter signature
        XCTAssertFalse(consoleLogger.lastLoggedMessage.contains("log(_:_:)"))
    }
    
    func testCustomTimestampFormat() {
        let config = ConsoleLoggerConfig(
            showTimestamp: true,
            timestampFormat: "yyyy-MM-dd HH:mm:ss"
        )
        let logger = TestableConsoleLogger(config: config)
        logger.info("Custom timestamp test", nil, nil, #file, #fileID, #function, #line)
        // Should match the custom timestamp format pattern
        XCTAssertTrue(logger.lastLoggedMessage.matches("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}:"))
    }
    
    func testModuleNameMapper() {
        let config = ConsoleLoggerConfig(
            showTimestamp: false,
            showInvocation: false,
            moduleNameMapper: { moduleName in
                // Custom mapper that converts module name to uppercase
                return moduleName.uppercased()
            }
        )
        let logger = TestableConsoleLogger(config: config)
        logger.info("Module mapper test", nil, nil, #file, #fileID, #function, #line)
        // Should contain the uppercase module name
        XCTAssertTrue(logger.lastLoggedMessage.contains("[ORCHARDTESTS]"))
    }
    
    func testConfigCanBeUpdated() {
        consoleLogger.config.showTimestamp = false
        consoleLogger.config.showInvocation = false
        consoleLogger.info("Config update test", nil, nil, #file, #fileID, #function, #line)
        // Should not contain timestamp
        XCTAssertFalse(consoleLogger.lastLoggedMessage.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
        // Should not contain invocation
        XCTAssertFalse(consoleLogger.lastLoggedMessage.contains("/ConsoleLoggerTests.testConfigCanBeUpdated"))
    }
    
    func testBackwardCompatibilityWithShowTimesStamp() {
        // Test that the old property name still works
        consoleLogger.showTimesStamp = false
        consoleLogger.info("Backward compat test", nil, nil, #file, #fileID, #function, #line)
        XCTAssertFalse(consoleLogger.lastLoggedMessage.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
        
        // Verify it updates the config
        XCTAssertFalse(consoleLogger.config.showTimestamp)
    }
    
    func testBuilderStyleInitialization() {
        let logger = TestableConsoleLogger { config in
            config.showTimestamp = false
            config.showInvocation = true
            config.timestampFormat = "HH:mm:ss"
        }
        
        logger.info("Builder test", nil, nil, #file, #fileID, #function, #line)
        
        // Should not contain timestamp
        XCTAssertFalse(logger.lastLoggedMessage.matches("\\d{2}:\\d{2}:\\d{2}\\.\\d{3}:"))
        // Should contain invocation
        XCTAssertTrue(logger.lastLoggedMessage.contains("/ConsoleLoggerTests.testBuilderStyleInitialization"))
        // Should contain message
        XCTAssertTrue(logger.lastLoggedMessage.contains("Builder test"))
    }
    
    func testBuilderStyleWithModuleNameMapper() {
        let logger = TestableConsoleLogger { config in
            config.showTimestamp = false
            config.showInvocation = false
            config.moduleNameMapper = { moduleName in
                return moduleName.replacingOccurrences(of: "OrchardTests", with: "Tests")
            }
        }
        
        logger.info("Mapper builder test", nil, nil, #file, #fileID, #function, #line)
        
        // Should contain the mapped module name
        XCTAssertTrue(logger.lastLoggedMessage.contains("[Tests]"))
        // Should NOT contain the original module name
        XCTAssertFalse(logger.lastLoggedMessage.contains("[OrchardTests]"))
    }
    
    func testBuilderStyleWithAllOptions() {
        let logger = TestableConsoleLogger { config in
            config.showTimestamp = true
            config.timestampFormat = "yyyy-MM-dd"
            config.showInvocation = true
            config.moduleNameMapper = { moduleName in
                return "[\(moduleName.uppercased())]"
            }
        }
        
        logger.info("All options test", nil, nil, #file, #fileID, #function, #line)
        
        // Should contain custom timestamp format
        XCTAssertTrue(logger.lastLoggedMessage.matches("\\d{4}-\\d{2}-\\d{2}:"))
        // Should contain mapped module name (with extra brackets from mapper)
        XCTAssertTrue(logger.lastLoggedMessage.contains("[[ORCHARDTESTS]]") || logger.lastLoggedMessage.contains("[ORCHARDTESTS]"))
        // Should contain invocation
        XCTAssertTrue(logger.lastLoggedMessage.contains("/ConsoleLoggerTests.testBuilderStyleWithAllOptions"))
    }
}
