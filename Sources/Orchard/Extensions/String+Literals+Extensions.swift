import Foundation

extension String {
    
    /// meant for use for #file
    var moduleNameFromFile: String {
        return NSString(string: self).pathComponents.first!
    }
    
    var fileFromfileId: String {
        guard let lastComponent = self.split(separator: "/").last else {
            return self
        }
        return String(lastComponent).replacingOccurrences(of: ".swift", with: "")
    }
}
