//
//  UITableViewExtensionTester.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource
import XCTest

final class UITableViewExtensionTester {

    private let tableView: MockTableView

    init() {
        tableView = MockTableView()
    }

    func registerCells() {
        tableView.register(reusableCellType: MockReusableCell.self)
    }

    func registerReusableViews() {
        tableView.registerFooterHeader(reusableViewType: MockReusableView.self)
    }

    func callDequeuMethod() {
        let _: MockReusableCell = tableView.dequeueCell(at: IndexPath(row: 0, section: 0))
    }

    func callDequeHeaderFooter() {
        let _: MockReusableView = tableView.dequeueView()
    }

    func testDequeueHasBeenCalled(numberOfTimes: Int,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
        XCTAssertEqual(tableView.dequeuedCellIDs.count, numberOfTimes, file: file, line: line)
    }

    func testClassRegisterHasBeenCalled(numberOfTimes: Int,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
        XCTAssertEqual(tableView.cellIDs.count, numberOfTimes, file: file, line: line)
    }

    func testDequeueViewHasBeenCalled(numberOfTimes: Int,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
        XCTAssertEqual(tableView.dequeuedReusableViewIDs.count, numberOfTimes, file: file, line: line)
    }

    func testClassRegisterViewHasBeenCalled(numberOfTimes: Int,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        XCTAssertEqual(tableView.reusableViewIDs.count, numberOfTimes, file: file, line: line)
    }
}
