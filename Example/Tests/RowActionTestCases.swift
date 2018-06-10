//
//  RowActionTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import EZSource


final class RowActionTester {
    
    func testRowAction(action: RowAction,
                       equalsToConextual contextualAction: UIContextualAction,
                       file: StaticString = #file,
                       line: UInt = #line) {
        
        XCTAssertEqual(action.backgroundColor, contextualAction.backgroundColor,file: file, line: line)
        XCTAssertEqual(action.title, contextualAction.title,file: file, line: line)
        XCTAssertEqual(action.image, contextualAction.image,file: file, line: line)
    }
}

class RowActionTestCases: XCTestCase {
    
    func test_row_action_equals_to_context_action() {
        let rowAction = RowAction(action: {})
        rowAction.title = "TEST"
        rowAction.backgroundColor = .red
        rowAction.image = UIImage()
        RowActionTester().testRowAction(action: rowAction, equalsToConextual: rowAction.contextualAction)
    }
    
}
