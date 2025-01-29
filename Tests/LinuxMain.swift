import XCTest

@testable import GHALoggerTests

var tests: [XCTestCaseEntry] = [
	testCase([
		("testFromDoc", GHALoggerTests.testFromDoc),
		("testVisual1", GHALoggerTests.testVisual1),
		("testVisual2", GHALoggerTests.testVisual2),
		("testVisual2WithColonCheck", GHALoggerTests.testVisual2WithColonCheck),
		("testVisual3", GHALoggerTests.testVisual3),
		("testVisual4", GHALoggerTests.testVisual4),
	]),
]
XCTMain(tests)
