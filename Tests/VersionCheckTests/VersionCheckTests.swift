//
//  VersionCheckTests.swift
//  
//
//  Created by Emad Ghorbania on 18/11/2022.
//

import XCTest
@testable import VersionCheck
final class VersionCheckTests: XCTestCase {

    func testNoUpdate() async throws {
        let input = VersionCheck.isThereAnyUpdate(
            latestVersionValue: "1.0.0",
            minSupportedVersionValue: "1.0.0",
            currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.noUpdate
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }

    func testUpdateExist() async throws {
        let input = VersionCheck.isThereAnyUpdate(
            latestVersionValue: "1.0.1",
            minSupportedVersionValue: "1.0.0",
            currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.updateExist
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
    
    func testMustUpdate() async throws {
        let input = VersionCheck.isThereAnyUpdate(
            latestVersionValue: "1.0.1",
            minSupportedVersionValue: "1.0.1",
            currentAppVersion: "1.0.0")
        let expectedOutput = VersionCheck.UpdateResult.mustUpdate
        XCTAssertEqual(input, expectedOutput, "The output is not expected!")
    }
}
