//
//  _DPCiPADUITests.swift
//  3DPCiPADUITests
//
//  Created by Laurent B on 14/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import XCTest

class _DPCiPADUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
         XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testInitialStateIsCorrect() {
        let table = XCUIApplication().tables
        XCTAssertEqual(table.cells.count, 32, "There should be 32 rows initially")
    }
}
