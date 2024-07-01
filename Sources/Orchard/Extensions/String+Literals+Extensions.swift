extension String {
    /// meant for use for #file
    var moduleNameFromFile: String {
        // Get everything after "/Sources/"
        guard let range = self.range(of: "/Sources/") else {
            return self
        }
        
        let pathAfterSources = String(self[range.upperBound...])
        
        // Split by "/" to get path components and find the first one that follows "Sources/"
        let components = pathAfterSources.split(separator: "/")
        
        // If splitting fails or there is no component after "Sources/", return the modified filename
        return pathAfterSources
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
