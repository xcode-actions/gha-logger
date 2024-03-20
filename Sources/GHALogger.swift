import Foundation

import CLTLogger
import Logging



/**
 A log handler for GitHub Actions.
 
 This is a wrapper for a CLTLogger with some specific prefixes. */
public struct GHALogger : LogHandler {
	
	public static let metadataKeyForLogTitle = "log-title"
	
	public init(metadataProvider: Logger.MetadataProvider? = LoggingSystem.metadataProvider) {
		var constantsByLevel = CLTLogger.defaultConstantsByLogLevelForColors
		constantsByLevel[.critical]!.logPrefix = "\(SGR(.bold).rawValue)CRITICAL - " /* This will be modified dynamically, but we always want the bold and [critical]. */
		constantsByLevel[.error]!   .logPrefix = "" /* This will be set dynamically. */
		constantsByLevel[.warning]! .logPrefix = "" /* This will be set dynamically. */
		constantsByLevel[.notice]!  .logPrefix = "" /* This will be set dynamically. */
		/* Same as what GitHub does for notice level.
		 * Usually I set the reset before the colon, but GitHub sets it after. */
		constantsByLevel[.info]!    .logPrefix = "\(SGR(.bold).rawValue)Info:\(SGR.reset.rawValue) "
		constantsByLevel[.debug]!   .logPrefix = "" /* This will be set dynamically. */
		constantsByLevel[.trace]!   .logPrefix = "\(SGR(.fgColorTo256PaletteValue(247)).rawValue)[trace]\(SGR.reset.rawValue)" /* This will be modified dynamically, but we always want the [trace]. */
		self.cltLogger = .init(fd: .standardOutput, multilineMode: .disallowMultiline, constantsByLevel: constantsByLevel, metadataProvider: metadataProvider)
	}
	
	public var logLevel: Logger.Level {
		get {cltLogger.logLevel}
		set {cltLogger.logLevel = newValue}
	}
	
	public var metadataProvider: Logger.MetadataProvider? {
		get {cltLogger.metadataProvider}
		set {cltLogger.metadataProvider = newValue}
	}
	
	public var metadata: Logger.Metadata {
		get {cltLogger.metadata}
		set {cltLogger.metadata = newValue}
	}
	
	public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get {cltLogger[metadataKey: key]}
		set {cltLogger[metadataKey: key] = newValue}
	}
	
	public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
		let messageStr = message.description
		/* If the filename contains a space it’s ok.
		 * It seems impossible to escape a file name containing a comma though. */
		let ghMetadata = {
			let title: String?
			/* Note: We only check the “direct” metadata on purpose. */
			switch metadata?[Self.metadataKeyForLogTitle] {
				case .string(let str):            title = str
				case .stringConvertible(let str): title = str.description
				case .dictionary, .array, nil:
					title = messageStr.split(separator: "\n", omittingEmptySubsequences: true).first.flatMap(String.init)
			}
			return (
				                 "file=\(file.escapedForGitHubCommandPropertyValue())" +
				                ",line=\(line)" +
				(title.flatMap{ ",title=\($0.escapedForGitHubCommandPropertyValue())" } ?? "")
			)
		}
		var constants = cltLogger.constantsByLevel[level] ?? .init()
		switch level {
			case .critical, .error: constants.logPrefix = "::error \(  ghMetadata())::" + constants.logPrefix
			case .warning:          constants.logPrefix = "::warning \(ghMetadata())::" + constants.logPrefix
			case .notice:           constants.logPrefix = "::notice \( ghMetadata())::" + constants.logPrefix
			case .info:             (/* GitHub does not have an info log command, which makes sense actually as a log command creates an actual annotation (except the debug one, so they could’ve done it…). */)
			case .debug, .trace:    constants.logPrefix = "::debug::" + constants.logPrefix
		}
		/* We do not escape the new lines in the message as they will be removed anyway by our multiline mode, and new lines are improperly handled by GitHub. */
		cltLogger.log(constants: constants, level: level, message: "\(messageStr.escapedForGitHubCommandMessage(escapeNewLines: false))", metadata: metadata, source: source, file: file, function: function, line: line)
	}
	
	private var cltLogger: CLTLogger
	
}
