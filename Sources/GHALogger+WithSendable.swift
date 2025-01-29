import Foundation

import Logging



/* The @Sendable attribute is only available starting at Swift 5.5.
 * We make these methods only available starting at Swift 5.8 for our convenience (avoids creating another Package@swift-... file)
 *  and because for Swift <5.8 the non-@Sendable variants of the methods are available. */
extension GHALogger {
	
	@Sendable
	public init(label: String, metadataProvider: Logger.MetadataProvider? = LoggingSystem.metadataProvider) {
		self.init(metadataProvider: metadataProvider)
	}
	
}
