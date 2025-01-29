// swift-tools-version:5.1
import PackageDescription


let package = Package(
	name: "gha-logger",
	/* Not sure how to test for platforms for Swift pre-5.8; let’s not do it. */
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
		], path: "Sources"),
		.testTarget(name: "GHALoggerTests", dependencies: ["GHALogger"]),
	]
)
