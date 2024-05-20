//
//  Shoplive_iOS_ParkJiHoUITestsLaunchTests.swift
//  Shoplive_iOS_ParkJiHoUITests
//
//  Created by jiho park on 5/20/24.
//

import XCTest

final class Shoplive_iOS_ParkJiHoUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
