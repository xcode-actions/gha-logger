import Foundation



internal extension String {
	
	/* From <https://github.com/orgs/community/discussions/26736#discussioncomment-3253165>. */
	func escapedForGitHubCommandMessage(escapeNewLines: Bool = true) -> String {
		let noNewLinesReplacements = self
			.replacingOccurrences(of: "%",  with: "%25")
		guard escapeNewLines else {
			return noNewLinesReplacements
		}
		
		return noNewLinesReplacements
			.replacingOccurrences(of: "\r", with: "%0D")
			.replacingOccurrences(of: "\n", with: "%0A")
	}
	
	/* From <https://github.com/orgs/community/discussions/26736#discussioncomment-3253165>. */
	func escapedForGitHubCommandPropertyValue() -> String {
		return self
			.replacingOccurrences(of: "%",  with: "%25")
			.replacingOccurrences(of: "\r", with: "%0D")
			.replacingOccurrences(of: "\n", with: "%0A")
			.replacingOccurrences(of: ":",  with: "%3A")
			.replacingOccurrences(of: ",",  with: "%2C")
	}
	
}
