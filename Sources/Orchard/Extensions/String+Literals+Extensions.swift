extension String {
    
    var fileFromfileId: String {
        guard let lastComponent = self.split(separator: "/").last else {
            return self
        }
        return String(lastComponent).replacingOccurrences(of: ".swift", with: "")
    }
}
