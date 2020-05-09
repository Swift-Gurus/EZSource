//
//  UITableViewExtensionTests.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class UITableViewExtensionTests: XCTestCase {
    var tester: UITableViewExtensionTester!
    override func setUp() {
        super.setUp()
        tester = UITableViewExtensionTester()
    }
    
    func test_register_reusable_cell() {
        tester.registerCells()
        tester.testClassRegisterHasBeenCalled(numberOfTimes: 1)
    }
 
    func test_dequeue_at_index_path_calls_proper_method() {
        tester.registerCells()
        tester.callDequeuMethod()
        tester.testDequeueHasBeenCalled(numberOfTimes: 1)
    }
    
    func test_register_reusable_views() {
        tester.registerReusableViews()
        tester.testClassRegisterViewHasBeenCalled(numberOfTimes: 1)
    }
    
    func test_dequeue_view_at_index_path() {
        tester.registerReusableViews()
        tester.callDequeHeaderFooter()
        tester.testDequeueViewHasBeenCalled(numberOfTimes: 1)
    }
}
