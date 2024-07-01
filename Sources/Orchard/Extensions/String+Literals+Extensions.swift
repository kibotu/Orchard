extension String {
    /// meant for use for #file
    var moduleNameFromFile: String {
        // Get everything after "/Sources/"
        guard let range = self.range(of: "/Sources/") else {
            return self
        }
        
        return String(self[range.upperBound...])
    }
    
    /// e.g.
    /// ProfisPartnerEvents/EventsPlugin.swift -> EventsPlugin
    var fileFromfileId: String {
        guard let lastComponent = self.split(separator: "/").last else {
            return self
        }
        return String(lastComponent).replacingOccurrences(of: ".swift", with: "")
    }
}
