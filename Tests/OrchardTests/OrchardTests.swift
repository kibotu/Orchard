import XCTest
@testable import Orchard

class OrchardTests: XCTestCase {

    var mockLogger: MockLogger!

    override func setUp() {
        super.setUp()
        mockLogger = MockLogger()
        Orchard.loggers = [mockLogger]
    }

    override func tearDown() {
        Orchard.loggers = []
        mockLogger = nil
        super.tearDown()
    }

    func testVerboseLogging() {
        Orchard.v("Verbose message")
        XCTAssertEqual(mockLogger.lastLogLevel, .verbose)
        XCTAssertEqual(mockLogger.lastMessage, "Verbose message")
    }

    func testDebugLogging() {
        Orchard.d("Debug message")
        XCTAssertEqual(mockLogger.lastLogLevel, .debug)
        XCTAssertEqual(mockLogger.lastMessage, "Debug message")
    }

    func testInfoLogging() {
        Orchard.i("Info message")
        XCTAssertEqual(mockLogger.lastLogLevel, .info)
        XCTAssertEqual(mockLogger.lastMessage, "Info message")
    }

    func testWarningLogging() {
        Orchard.w("Warning message")
        XCTAssertEqual(mockLogger.lastLogLevel, .warning)
        XCTAssertEqual(mockLogger.lastMessage, "Warning message")
    }

    func testErrorLogging() {
        Orchard.e("Error message")
        XCTAssertEqual(mockLogger.lastLogLevel, .error)
        XCTAssertEqual(mockLogger.lastMessage, "Error message")
    }

    func testFatalLogging() {
        Orchard.f("Fatal message")
        XCTAssertEqual(mockLogger.lastLogLevel, .fatal)
        XCTAssertEqual(mockLogger.lastMessage, "Fatal message")
    }

    func testLoggingWithError() {
        let error = NSError(domain: "TestDomain", code: 100, userInfo: nil)
        Orchard.e("Error occurred", error)
        XCTAssertEqual(mockLogger.lastLogLevel, .error)
        XCTAssertEqual(mockLogger.lastMessage, "Error occurred")
        XCTAssertEqual(mockLogger.lastError as NSError?, error)
    }

    func testLoggingWithArgs() {
        Orchard.i("User action", ["userId": "123", "action": "login"])
        XCTAssertEqual(mockLogger.lastLogLevel, .info)
        XCTAssertEqual(mockLogger.lastMessage, "User action")
        XCTAssertEqual(mockLogger.lastArgs?["userId"] as? String, "123")
        XCTAssertEqual(mockLogger.lastArgs?["action"] as? String, "login")
    }

    func testTagging() {
        Orchard.tag("NetworkManager").i("Network request")
        XCTAssertEqual(mockLogger.lastTag, "NetworkManager")
        XCTAssertEqual(mockLogger.lastMessage, "Network request")
    }

    func testIconSetting() {
        Orchard.icon("🌐").i("Custom icon log")
        XCTAssertEqual(mockLogger.lastIcon, "🌐")
        XCTAssertEqual(mockLogger.lastMessage, "Custom icon log")
    }

    func testChainedTagAndIcon() {
        Orchard.tag("UI").icon("👁️").d("UI update")
        XCTAssertEqual(mockLogger.lastTag, "UI")
        XCTAssertEqual(mockLogger.lastIcon, "👁️")
        XCTAssertEqual(mockLogger.lastMessage, "UI update")
    }
}


