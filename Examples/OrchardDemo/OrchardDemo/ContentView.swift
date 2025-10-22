import SwiftUI
import Orchard

struct ContentView: View {
    @State private var logs: [LogEntry] = []
    @State private var customMessage: String = ""
    @State private var selectedLevel: Orchard.Level = .info
    @State private var useTag: Bool = false
    @State private var customTag: String = "CustomTag"
    @State private var useIcon: Bool = false
    @State private var customIcon: String = "🎯"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Log Display
                List {
                    ForEach(logs) { log in
                        LogRowView(log: log)
                    }
                }
                .listStyle(.plain)
                
                Divider()
                
                // Controls
                ScrollView {
                    VStack(spacing: 16) {
                        // Message Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Message")
                                .font(.headline)
                            TextField("Enter log message", text: $customMessage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Level Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Log Level")
                                .font(.headline)
                            Picker("Log Level", selection: $selectedLevel) {
                                Text("Verbose").tag(Orchard.Level.verbose)
                                Text("Debug").tag(Orchard.Level.debug)
                                Text("Info").tag(Orchard.Level.info)
                                Text("Warning").tag(Orchard.Level.warning)
                                Text("Error").tag(Orchard.Level.error)
                                Text("Fatal").tag(Orchard.Level.fatal)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Tag Controls
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Use Tag", isOn: $useTag)
                                .font(.headline)
                            if useTag {
                                TextField("Tag name", text: $customTag)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        // Icon Controls
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Use Custom Icon", isOn: $useIcon)
                                .font(.headline)
                            if useIcon {
                                TextField("Icon", text: $customIcon)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: logMessage) {
                                Label("Log Message", systemImage: "paperplane.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            
                            HStack(spacing: 12) {
                                Button(action: runAllExamples) {
                                    Label("Run Examples", systemImage: "play.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                
                                Button(action: { logs.removeAll() }) {
                                    Label("Clear", systemImage: "trash")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 350)
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .navigationTitle("🍎 Orchard Demo")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setupOrchard()
                addWelcomeMessage()
            }
        }
    }
    
    private func setupOrchard() {
        // Setup console logger with builder-style configuration
        let consoleLogger = ConsoleLogger { config in
            config.showTimestamp = true
            config.timestampFormat = "yyyy-MM-dd HH:mm:ss.SSS"  // Custom date format
            config.showInvocation = true
            config.moduleNameMapper = { module in
                return module.replacingOccurrences(of: "OrchardDemo", with: "Demo")
            }
        }
        Orchard.loggers.append(consoleLogger)
        
        // Setup UI logger
        let uiLogger = UILogger { entry in
            DispatchQueue.main.async {
                logs.insert(entry, at: 0)
                // Keep only last 50 logs
                if logs.count > 50 {
                    logs = Array(logs.prefix(50))
                }
            }
        }
        Orchard.loggers.append(uiLogger)
    }
    
    private func addWelcomeMessage() {
        logs.append(LogEntry(
            level: .info,
            message: "Welcome to Orchard Demo! 🌳",
            tag: nil,
            icon: "🍎"
        ))
    }
    
    private func logMessage() {
        let message = customMessage.isEmpty ? "Sample log message" : customMessage
        
        var orchard = Orchard.self
        if useTag {
            orchard = orchard.tag(customTag)
        }
        if useIcon, let iconChar = customIcon.first {
            orchard = orchard.icon(iconChar)
        }
        
        switch selectedLevel {
        case .verbose: orchard.v(message)
        case .debug: orchard.d(message)
        case .info: orchard.i(message)
        case .warning: orchard.w(message)
        case .error: orchard.e(message)
        case .fatal: orchard.f(message)
        }
    }
    
    private func runAllExamples() {
        // Clear previous logs
        logs.removeAll()
        
        // Basic log levels
        Orchard.v("Verbose: Detailed debug information")
        Orchard.d("Debug: Development information")
        Orchard.i("Info: General information")
        Orchard.w("Warning: Something needs attention")
        Orchard.e("Error: Something went wrong")
        Orchard.f("Fatal: Critical error!")
        
        // With tags
        Orchard.tag("Network").i("HTTP request completed successfully")
        Orchard.tag("Database").d("Query executed in 45ms")
        Orchard.tag("Auth").w("Token will expire in 5 minutes")
        
        // With custom icons
        Orchard.icon("🚀").i("App launched successfully")
        Orchard.icon("💾").d("Data saved to disk")
        Orchard.icon("🌐").i("Connected to server")
        
        // With tags and icons combined
        Orchard.tag("Payment").icon("💳").i("Payment processed: $99.99")
        Orchard.tag("Analytics").icon("📊").d("Event tracked: button_click")
        
        // With error
        enum DemoError: Error, CustomStringConvertible {
            case sampleError
            case networkTimeout
            
            var description: String {
                switch self {
                case .sampleError:
                    return "DemoError: A sample error occurred"
                case .networkTimeout:
                    return "DemoError: Network request timed out"
                }
            }
        }
        Orchard.e("Operation failed", DemoError.sampleError)
        Orchard.tag("Network").icon("⚠️").e("Request timeout", DemoError.networkTimeout)
        
        // With arguments (additional context)
        Orchard.i("User logged in", ["userId": "12345", "userName": "John"])
        Orchard.tag("Analytics").d("Screen viewed", ["screen": "home", "duration": "5.2s"])
    }
}

struct LogRowView: View {
    let log: LogEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Icon
            Text(log.icon ?? log.level.icon.description)
                .font(.title2)
                .frame(width: 30)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                // Header
                HStack {
                    Text(log.level.displayValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(colorForLevel(log.level))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(colorForLevel(log.level).opacity(0.2))
                        .cornerRadius(4)
                    
                    if let tag = log.tag {
                        Text("[\(tag)]")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Text(log.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Message
                Text(log.message)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 6)
    }
    
    private func colorForLevel(_ level: Orchard.Level) -> Color {
        switch level {
        case .verbose: return .gray
        case .debug: return .blue
        case .info: return .green
        case .warning: return .orange
        case .error: return .red
        case .fatal: return .purple
        }
    }
}

// MARK: - Supporting Types

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp = Date()
    let level: Orchard.Level
    let message: String
    let tag: String?
    let icon: String?
}

class UILogger: Orchard.Logger {
    public init(onLog: @escaping (LogEntry) -> Void) {
        self.onLog = onLog
    }
    
    public let level: Orchard.Level = .verbose
    public var tag: String?
    public var icon: Character?
    private let onLog: (LogEntry) -> Void
    
    public func verbose(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .verbose, message: message, error: error, args: args)
    }
    
    public func debug(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .debug, message: message, error: error, args: args)
    }
    
    public func info(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .info, message: message, error: error, args: args)
    }
    
    public func warning(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .warning, message: message, error: error, args: args)
    }
    
    public func error(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .error, message: message, error: error, args: args)
    }
    
    public func fatal(_ message: String?, _ error: Error?, _ args: [String : CustomStringConvertible]?, _ file: String, _ fileId: String, _ function: String, _ line: Int) {
        log(level: .fatal, message: message, error: error, args: args)
    }
    
    private func log(level: Orchard.Level, message: String?, error: Error?, args: [String: CustomStringConvertible]?) {
        var logMessage = message ?? ""
        if let error = error {
            logMessage += logMessage.isEmpty ? "" : " "
            logMessage += "\(error.localizedDescription)"
        }
        if let args = args, !args.isEmpty {
            logMessage += logMessage.isEmpty ? "" : " "
            logMessage += "\(args)"
        }
        
        let entry = LogEntry(
            level: level,
            message: logMessage,
            tag: tag,
            icon: icon?.description
        )
        onLog(entry)
        
        // Reset tag and icon
        tag = nil
        icon = nil
    }
}

#Preview {
    ContentView()
}

