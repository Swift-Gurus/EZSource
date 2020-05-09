//
//  TableViewRowTester.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright (c) 2020 AlexHmelevskiAG. All rights reserved.
//

import Foundation
@testable import EZSource
import XCTest

final class TableViewRowTester {
    var row: TableViewRow<MockReusableCell>
    var action: RowAction!
    var actionTester = RowActionTester()
    init() {
        row = TableViewRow<MockReusableCell>(model: "test",
                                             traillingSwipeConfiguration: RowActionSwipeConfiguration(),
                                             leadingSwipeConfiguration: RowActionSwipeConfiguration())
        actionTester = RowActionTester()
    }
    
    func createAction() {
        action = RowAction(action: {})
        action.title = "TEST"
        action.backgroundColor = .red
    }
    
    func addIntoLeadingActions() {
       row.addRowLeadingActions([action])
    }
    
    func addIntoTraillingActions() {
        row.addRowTrailingActions([action])
    }
    
    func recreateRowWithLeadingAction() {
        row = row.addedRowLeadingActions([action])
    }
    func recreateRowWithTraillingAction() {
        row = row.addedRowTrailingActions([action])
    }
    
    func testRowContainsCreatedLeadingAction(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(row.leadingSwipeConfiguration.actions.compactMap({$0.title}), [action.title],file: file, line: line)
        actionTester.testRowAction(action: action,
                                   equalsToConextual: row.leadingActionSwipeConfiguration.contextualActions.first! )
    }
    
    func testRowContainsCreatedTraillingAction(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(row.traillingSwipeConfiguration.actions.compactMap({$0.title}), [action.title],file: file, line: line)
        actionTester.testRowAction(action: action,
                                   equalsToConextual: row.trailingActionSwipeConfiguration.contextualActions.first! )
    }

}



