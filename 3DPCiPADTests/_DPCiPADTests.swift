//
//  _DPCiPADTests.swift
//  3DPCiPADTests
//
//  Created by Laurent B on 01/12/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import XCTest
@testable import _DPCiPAD

class _DPCiPADTests: XCTestCase {
    //This creates a placeholder for a cell, which is the System Under Test (SUT), or the object this test case class is concerned with testing.
    //var sut: models!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
      //  sut = ViewController()
        //sut.configure(for model: Model)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //release your SUT object
        //sut = nil
        super.tearDown()
    }

    func testModelssLoaded() {
        let testModels = Models()
        XCTAssertEqual(testModels.models.count, 0, "Models before init must be 0")
    }

}
