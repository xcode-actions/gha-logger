import Foundation



public struct GHACommand : Sendable {
	
	public static let addMask:    GHACommand = .init(command: "add-mask")!
	public static let startGroup: GHACommand = .init(command: "group")!
	public static let endGroup:   GHACommand = .init(command: "endgroup")!
	
	public static func notice(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return .init(command: "notice", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 })!
	}
	public static func warning(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return .init(command: "warning", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 })!
	}
	public static func error(title: String, file: String? = nil, line: UInt? = nil, endLine: UInt? = nil, column: UInt? = nil, endColumn: UInt? = nil) -> GHACommand {
		return .init(command: "error", parameters: [
			"title": title,
			"file": file,
			"col": column.flatMap(String.init),
			"endColumn": endColumn.flatMap(String.init),
			"line": line.flatMap(String.init),
			"endLine": endLine.flatMap(String.init),
		].compactMapValues{ $0 })!
	}
	public static let debug: GHACommand = .init(command: "debug")!
	
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
		let parameters = parameters.map{ "\($0.key)=\($0.value.escapedForGitHubCommandPropertyValue())" }.joined(separator: ",")
		return "::\(command)\(parameters.isEmpty ? "" : " ")\(parameters)::"
	}
	
	/* This list of chars is probably not enough in itself, but it will do. */
	private static let parametersChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-0123456789")
	
}
