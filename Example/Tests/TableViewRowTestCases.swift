//
//  TableViewRowTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import EZSource

class TableViewRowTestCases: XCTestCase {
    
   
    var tester = TableViewRowTester()
   
    override func setUp() {
        super.setUp()
        tester = TableViewRowTester()
    }
    
    func test_adds_leading_action() {
        tester.createAction()
        tester.addIntoLeadingActions()
        tester.testRowContainsCreatedLeadingAction()
    }
    
    func test_adds_trailling_action() {
        tester.createAction()
        tester.addIntoTraillingActions()
        tester.testRowContainsCreatedTraillingAction()
    }
    
    func test_recreates_new_row_with_trailling_actions() {
        tester.createAction()
        tester.recreateRowWithTraillingAction()
        tester.testRowContainsCreatedTraillingAction()
    }
    
    func test_recreates_new_row_with_leading_actions() {
        tester.createAction()
        tester.recreateRowWithLeadingAction()
        tester.testRowContainsCreatedLeadingAction()
    }
    
}
