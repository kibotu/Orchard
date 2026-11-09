import Foundation

extension String {
    var moduleNameFromFile: String {
        NSString(string: self).pathComponents.first ?? self
    }
    
    var fileFromfileId: String {
        guard let lastComponent = self.split(separator: "/").last else {
            return self
        }
        return String(lastComponent).replacingOccurrences(of: ".swift", with: "")
    }
}
