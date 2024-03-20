// swift-tools-version:5.3
import PackageDescription


let package = Package(
	name: "gha-logger",
	platforms: [
		.macOS(.v11),
		.tvOS(.v14),
		.iOS(.v14),
		.watchOS(.v7)
	],
	products: [
		.library(name: "GHALogger", targets: ["GHALogger"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log.git",          from: "1.5.1"),
		.package(url: "https://github.com/xcode-actions/clt-logger.git", from: "0.9.0-beta.3"),
	],
	targets: [
		.target(name: "GHALogger", dependencies: [
			.product(name: "CLTLogger", package: "clt-logger"),
			.product(name: "Logging",   package: "swift-log"),
		], path: "Sources"),
		.testTarget(name: "GHALoggerTests", dependencies: ["GHALogger"], path: "Tests"),
	]
)
