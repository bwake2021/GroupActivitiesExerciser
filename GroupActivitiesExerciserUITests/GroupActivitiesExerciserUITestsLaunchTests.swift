// GroupActivitiesExerciserUITestsLaunchTests.swift
//
// Created by Bob Wakefield on 10/2/21.
// for GroupActivitiesExerciser
//
// Using Swift 5.0
// Running on macOS 11.6
//
// 
//

import XCTest

class GroupActivitiesExerciserUITestsLaunchTests: XCTestCase {

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
