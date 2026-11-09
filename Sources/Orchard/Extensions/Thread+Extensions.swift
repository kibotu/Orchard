import Foundation

public extension Thread {
    static var callStack: [String] {
        Thread
            .callStackSymbols // drop Thread.callStack
            .dropFirst()
            .map { line in
                let parts = line.split(separator: " ")
                guard parts.count > 3 else { return line }
                let module = parts[1]
                let method = demangle("\(parts[3])")
                return "[\(module)] \(method)"
            }
    }
    
    static func printStackTrace() {
        callStack
            .dropFirst() // drop Thread.printStacktrace
            .forEach { line in
                Orchard.d("[\(Thread.betterIdentifier)]\(line)")
            }
    }
    
    static var betterIdentifier: String {
           if isMainThread {
               return "Main"
           } else {
               // Attempt to get a thread number by parsing the description since there's no public API for it.
               // Note: This is not guaranteed to work in all future versions of Swift.
               let description = Thread.current.description
               let nsrange = NSRange(description.startIndex..<description.endIndex, in: description)
               
               if let regex = try? NSRegularExpression(pattern: "number = (\\d+)", options: []),
                  let match = regex.firstMatch(in: description, options: [], range: nsrange),
                  let range = Range(match.range(at: 1), in: description) {
                   let number = String(description[range])
                   return "Thread-\(number)"
               } else {
                   return "Thread-<\(Unmanaged.passUnretained(Thread.current).toOpaque())>"
               }
           }
       }
}

public typealias SwiftDemangle = @convention(c) (_ mangledName: UnsafePointer<CChar>?, _ mangledNameLength: Int, _ outputBuffer: UnsafeMutablePointer<CChar>?, _ outputBufferSize: UnsafeMutablePointer<Int>?, _ flags: UInt32) -> UnsafeMutablePointer<CChar>?

// swiftlint:disable identifier_name force_unwrapping
nonisolated(unsafe) public let RTLD_DEFAULT = dlopen(nil, RTLD_NOW)
nonisolated(unsafe) public let demangleSymbol = dlsym(RTLD_DEFAULT, "swift_demangle")!
nonisolated(unsafe) public let cDemangle = unsafeBitCast(demangleSymbol, to: SwiftDemangle.self)
// swiftlint:enable identifier_name force_unwrapping

public func demangle(_ mangled: String) -> String {
    mangled.withCString { cString in
        var size: Int = 0
        let ptr = cDemangle(cString, strlen(cString), nil, &size, 0)
        
        guard let result = ptr else { return mangled }
        
        let demangledName = String(cString: result)
        
        free(result)
        
        return demangledName
    }
}
