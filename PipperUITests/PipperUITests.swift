//
//  PipperUITests.swift
//  PipperUITests
//
//  Created by Federico Curzel on 27/07/22.
//

import XCTest

class PipperUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
