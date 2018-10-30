//
//  TableViewRowTester.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource
import XCTest

final class TableViewRowTester {
    var row: TableViewRow<MockReusableCell>
    var action: RowAction!
    var actionTester = RowActionTester()
    init() {
        row = TableViewRow<MockReusableCell>(model: "test")
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
        XCTAssertEqual(row.leadingActions.compactMap({$0.title}), [action.title],file: file, line: line)
        actionTester.testRowAction(action: action, equalsToConextual: row.leadingContextualActions.first! )
    }
    
    func testRowContainsCreatedTraillingAction(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(row.traillingActions.compactMap({$0.title}), [action.title],file: file, line: line)
        actionTester.testRowAction(action: action, equalsToConextual: row.trailingContextualActions.first! )
    }
    
    

}



