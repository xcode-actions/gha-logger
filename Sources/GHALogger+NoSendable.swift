import Foundation

import Logging



extension GHALogger {
	
	public init(label: String, metadataProvider: Logger.MetadataProvider? = LoggingSystem.metadataProvider) {
		self.init(metadataProvider: metadataProvider)
	}
	
}
