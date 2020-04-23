//
//  SectionUpdateSnapshotTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import EZSource

class SectionUpdateSnapshotTestCases: XCTestCase {

    var snapShotToTest: SectionUpdateSnapshot!
    var mockSection: SectionalMock<MockReusableCell>!
    
    override func setUpWithError() throws {
        mockSection = .init(id: "TEST")
        snapShotToTest = .init(section: mockSection)
    }

    func test_addition_of_an_element() {
        let testString = "TEST"
        let index = createZeroIndexPath(for: 0)
        let newSnapShot = snapShotToTest.added(inserted: rowWithModel(model: testString),
                                               at: index)
        let indexesSnapshot = newSnapShot.indexesSnapshot
        XCTAssertEqual(indexesSnapshot.inserted, [index])
    }
    
    func test_addition_of_an_element_outside_of_bounds() {
         let testString = "TEST"
         let index = createZeroIndexPath(for: 10)
         let newSnapShot = snapShotToTest.added(inserted: rowWithModel(model: testString),
                                                at: index)
         let indexesSnapshot = newSnapShot.indexesSnapshot
         XCTAssertEqual(indexesSnapshot.inserted, [])
    }
    
    func test_updates_element() {
        let testString1 = "TEST"
        let index1 = createZeroIndexPath(for: 0)
        let row1 = rowWithModel(model: testString1)
        
       
        let index2 = createZeroIndexPath(for: 1)
       
        
        let testString2 = "TEST2"
        let row2 = rowWithModel(model: testString2)
        
        let newSnapShot = snapShotToTest.added(inserted: row1, at: index1)
                                        .added(inserted: row1, at: index2)
                                        .added(inserted: row1, at: index2)
                                        .added(updated: row2, at: index2)
                                        
                                         
        let indexesSnapshot = newSnapShot.indexesSnapshot
         XCTAssertEqual(indexesSnapshot.inserted, [index1, index2])
         XCTAssertEqual(indexesSnapshot.updated, [index2])
         XCTAssertEqual(models(from: newSnapShot), [testString1, testString2])
         
    }
    
    private func models(from snapshot: SectionUpdateSnapshot) -> [String] {
        snapshot.section.rows.compactMap({ $0 as? TableViewRow<MockReusableCell> })
                             .map({ $0.model })
    }
    
    
    private func rowWithModel(model: String) -> TableViewRow<MockReusableCell> {
        .init(model: model)
    }
    
    private func createZeroIndexPath(for row: Int) -> IndexPath {
        .init(row: row, section: 0)
    }
}
