import Foundation

/// Configuration for ConsoleLogger behavior and formatting
public struct ConsoleLoggerConfig: Sendable {
    
    /// Determines whether to show timestamps in log messages
    public var showTimestamp: Bool
    
    /// Date format string for timestamps (e.g., "HH:mm:ss.SSS")
    public var timestampFormat: String
    
    /// Determines whether to show invocation details (file, function, line) in log messages
    public var showInvocation: Bool
    
    /// Optional closure to map/transform module names
    /// Takes the fileId as input and returns a transformed module name
    public var moduleNameMapper: (@Sendable (String) -> String)?
    
    /// Default configuration with standard settings
    public static let `default` = ConsoleLoggerConfig(
        showTimestamp: true,
        timestampFormat: "HH:mm:ss.SSS",
        showInvocation: true,
        moduleNameMapper: nil
    )
    
    /// Initializes a new configuration with the specified settings
    /// - Parameters:
    ///   - showTimestamp: Whether to show timestamps (default: true)
    ///   - timestampFormat: Date format string for timestamps (default: "HH:mm:ss.SSS")
    ///   - showInvocation: Whether to show invocation details (default: true)
    ///   - moduleNameMapper: Optional closure to transform module names (default: nil)
    public init(
        showTimestamp: Bool = true,
        timestampFormat: String = "HH:mm:ss.SSS",
        showInvocation: Bool = true,
        moduleNameMapper: (@Sendable (String) -> String)? = nil
    ) {
        self.showTimestamp = showTimestamp
        self.timestampFormat = timestampFormat
        self.showInvocation = showInvocation
        self.moduleNameMapper = moduleNameMapper
    }
}

