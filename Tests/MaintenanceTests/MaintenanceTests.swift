//
//  MaintenanceTests.swift
//
//
//  Created by Emad Ghorbania on 18/11/2022.
//

import XCTest
@testable import Maintenance
import Firebase
final class MaintenanceTests: XCTestCase {

    func testFullscreen() async throws {
        let input = Maintenance.isThereAnyMaintenance(
            fullscreen: true,
            banner: false,
            fullscreenDetail: Maintenance.Detail(title: "FullScreen", body: "Body Test"),
            bannerDetail: Maintenance.Detail(title: "Banner", body: "Body Test"))
        let expectedOutput = Maintenance.StatusType.fullscreen
        XCTAssertEqual(input?.0, expectedOutput, "The output is not expected!")
    }
    func testBanner() async throws {
        let input = Maintenance.isThereAnyMaintenance(
            fullscreen: false,
            banner: true,
            fullscreenDetail: Maintenance.Detail(title: "FullScreen", body: "Body Test"),
            bannerDetail: Maintenance.Detail(title: "Banner", body: "Body Test"))
        let expectedOutput = Maintenance.StatusType.banner
        XCTAssertEqual(input?.0, expectedOutput, "The output is not expected!")
    }
    
    func testFullscreenDetails() async throws {
        let input = Maintenance.isThereAnyMaintenance(
            fullscreen: true,
            banner: false,
            fullscreenDetail: Maintenance.Detail(title: "FullScreen", body: "Body Test"),
            bannerDetail: Maintenance.Detail(title: "Banner", body: "Body Test"))
        let expectedOutput = Maintenance.Detail(title: "FullScreen", body: "Body Test")
        XCTAssertEqual(input?.1, expectedOutput, "The output is not expected!")
    }
    func testBannerDetails() async throws {
        let input = Maintenance.isThereAnyMaintenance(
            fullscreen: false,
            banner: true,
            fullscreenDetail: Maintenance.Detail(title: "FullScreen", body: "Body Test"),
            bannerDetail: Maintenance.Detail(title: "Banner", body: "Body Test"))
        let expectedOutput = Maintenance.Detail(title: "Banner", body: "Body Test")
        XCTAssertEqual(input?.1, expectedOutput, "The output is not expected!")
    }
}
