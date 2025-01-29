import Foundation
import XCTest

@testable import GHALoggerTests



var tests: [XCTestCaseEntry] = [
	testCase([
		("testFromDoc", GHALoggerTests.testFromDoc),
		("testVisual1", GHALoggerTests.testVisual1),
		("testVisual2", GHALoggerTests.testVisual2),
		("testVisual3", GHALoggerTests.testVisual3),
		("testVisual4", GHALoggerTests.testVisual4),
	]),
]
#if !os(WASI)
XCTMain(tests)

#else
/* Compilation fails for Swift <5.5… */
//await XCTMain(tests)

/* Let’s print a message to inform the tests on WASI are disabled. */
import struct CLTLogger.SGR
try FileHandle.standardError.write(contentsOf: Data("""
\(SGR(.fgColorTo4BitBrightRed, .bold).rawValue)Tests are disabled on WASI\(SGR.reset.rawValue):
\(SGR(.fgColorTo256PaletteValue(245)).rawValue)CLTLogger is compatible with Swift <5.4, so we have to add a LinuxMain file in which we call XCTMain.
On WASI the XCTMain function is async, so we have to #if the XCTMain call, one with the await keyword, the other without.
However, on Swift <5.5 the LinuxMain setup like this does not compile because the old compiler does not know the await keyword
 (even though the whole code is ignored because we do not compile for WASI when compiling with an old compiler).
I also tried doing a #if swift(>=5.5) check, but that does not work either.\(SGR.reset.rawValue)

\(SGR(.fgColorTo4BitMagenta, .bold).rawValue)To temporarily enable the tests for WASI, uncomment the `await XCTMain(tests)` line in LinuxMain.swift.\(SGR.reset.rawValue)

""".utf8))

#endif
