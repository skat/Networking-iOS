//
//  VersionCheckTests.swift
//  
//
//  Created by Emad Ghorbania on 18/11/2022.
//

import XCTest
@testable import VersionCheck
import Firebase
final class VersionCheckTests: XCTestCase {

    func testNoUpdate() async throws {
        let input = VersionCheck.isThereAnyUpdate(latestVersionValue: "1.0.0",
                                                  minSupportedVersionValue: "1.0.0",
                                                  currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.noUpdate
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }

    func testUpdateExist() async throws {
        let input = VersionCheck.isThereAnyUpdate(latestVersionValue: "1.0.1",
                                                  minSupportedVersionValue: "1.0.0",
                                                  currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.updateExist
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
    
    func testMustUpdate() async throws {
        let input = VersionCheck.isThereAnyUpdate(latestVersionValue: "1.0.1",
                                                  minSupportedVersionValue: "1.0.1",
                                                  currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.mustUpdate
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
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
