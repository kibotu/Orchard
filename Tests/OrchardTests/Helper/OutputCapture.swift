import XCTest
@testable import Orchard

class OutputCapture {
    private var originalStdout: Int32?
    private var pipe: Pipe?

    func startCapture() {
        originalStdout = dup(FileHandle.standardOutput.fileDescriptor)
        pipe = Pipe()
        dup2(pipe!.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
    }

    func stopCapture() -> String {
        pipe?.fileHandleForWriting.closeFile()
        let data = pipe?.fileHandleForReading.readDataToEndOfFile()
        dup2(originalStdout!, FileHandle.standardOutput.fileDescriptor)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
}
