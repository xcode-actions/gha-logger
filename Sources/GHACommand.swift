import Foundation



public struct GHACommand : GHALogger_Sendable {
	
	public static let addMask    = GHACommand(command: "add-mask")!
	public static let startGroup = GHACommand(command: "group")!
	public static let endGroup   = GHACommand(command: "endgroup")!
	
	public static func notice(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return GHACommand(command: "notice", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 } as [String: String])!
	}
	public static func warning(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return GHACommand(command: "warning", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 } as [String: String])!
	}
	public static func error(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return GHACommand(command: "error", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 } as [String: String])!
	}
	public static let debug = GHACommand(command: "debug")!
	
	public var command: String
	public var parameters: [String: String]
	
	public init?(command: String, parameters: [String: String] = [:]) {
		guard command.rangeOfCharacter(from: Self.parametersChars.inverted, options: .literal) == nil,
				parameters.allSatisfy({ $0.key.rangeOfCharacter(from: Self.parametersChars.inverted, options: .literal) == nil })
		else {
			return nil
		}
		self.command = command
		self.parameters = parameters
	}
	
	public func gitHubString() -> String {
		let parametersStr = parameters.map{ "\($0.key)=\($0.value.escapedForGitHubCommandPropertyValue())" }.joined(separator: ",")
		return "::\(command)\(parametersStr.isEmpty ? "" : " ")\(parametersStr)::"
	}
	
	/* This list of chars is probably not enough in itself, but it will do. */
	private static let parametersChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-0123456789")
	
}
