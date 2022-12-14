//
//  HelpersTests.swift
//
//
//  Created by Emad Ghorbania on 18/11/2022.
//

import XCTest
@testable import Helpers

final class HelpersTests: XCTestCase {
    func testVersionCompareOrderedAscending3Version() {
        let versionOne = "1.0.0"
        let versionTwo = "2.0.0"
        let input = versionOne.versionCompare(versionTwo)
        let expectedOutput = ComparisonResult.orderedAscending
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
    func testVersionCompareOrderedAscending2Version() {
        let versionOne = "1.0"
        let versionTwo = "2.0.0"
        let input = versionOne.versionCompare(versionTwo)
        let expectedOutput = ComparisonResult.orderedAscending
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
    func testVersionCompareOrderedAscending1Version() {
        let versionOne = "1"
        let versionTwo = "2.0.0"
        let input = versionOne.versionCompare(versionTwo)
        let expectedOutput = ComparisonResult.orderedAscending
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }

}
