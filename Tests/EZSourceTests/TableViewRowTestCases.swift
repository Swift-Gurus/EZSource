//
//  TableViewRowTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright (c) 2020 AlexHmelevskiAG. All rights reserved.
//

import XCTest
@testable import EZSource

class TableViewRowTestCases: XCTestCase {

    var tester = TableViewRowTester()

    override func setUp() {
        super.setUp()
        tester = TableViewRowTester()
    }

    func test_adds_leading_action() throws {
        tester.createAction()
        tester.addIntoLeadingActions()
        try tester.testRowContainsCreatedLeadingAction()
    }

    func test_adds_trailling_action() throws {
        tester.createAction()
        tester.addIntoTraillingActions()
        try tester.testRowContainsCreatedTraillingAction()
    }

    func test_recreates_new_row_with_trailling_actions() throws {
        tester.createAction()
        tester.recreateRowWithTraillingAction()
        try tester.testRowContainsCreatedTraillingAction()
    }

    func test_recreates_new_row_with_leading_actions() throws {
        tester.createAction()
        tester.recreateRowWithLeadingAction()
        try tester.testRowContainsCreatedLeadingAction()
    }

}
