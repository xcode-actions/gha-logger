// swift-tools-version:5.8
import PackageDescription


//let swiftSettings: [SwiftSetting] = []
let swiftSettings: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency")]

let package = Package(
	name: "gha-logger",
	platforms: [
		.macOS(.v11),
		.tvOS(.v14),
		.iOS(.v14),
		.watchOS(.v7),
	],
	products: [
		.library(name: "GHALogger", targets: ["GHALogger"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log.git",          from: "1.5.1"),
		.package(url: "https://github.com/xcode-actions/clt-logger.git", from: "1.0.0-rc"),
	],
	targets: [
		.target(name: "GHALogger", dependencies: [
			.product(name: "CLTLogger", package: "clt-logger"),
			.product(name: "Logging",   package: "swift-log"),
		], path: "Sources", exclude: ["GHALogger+NoSendable.swift"], swiftSettings: swiftSettings),
		.testTarget(name: "GHALoggerTests", dependencies: ["GHALogger"], swiftSettings: swiftSettings),
	]
)
