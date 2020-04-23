//
//  SectionSourceTester.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-17.
//  Copyright (c) 2020 AlexHmelevskiAG. All rights reserved.
//

import Foundation
import XCTest
@testable import EZSource

final class SectionSourceTester {
    private let defaultSectionID =  "defaultSection"
    var initalRowsNames = ["Row1","Row2", "Row2"]
    var updatedRowNames = ["UpdatedRow1","UpdatedRow2", "UpdatedRow2"]
    var secondSectionRowNames = ["S1", "S2", "S3"]
    var sourceToTest = SectionSource()
    let factory = SectionableFactoryMock()
   
    
    func emulateReload(using sections: [Sectionable]) {
        sourceToTest.update(with: sections)
    }
    
    @discardableResult
    func emulateUpdates(using sectionUpdates: [TableViewSectionUpdate]) -> UpdateSourceSnapshot {
        return sourceToTest.update(with: sectionUpdates)
    }
    
    func check_if_snapshot_is_equal_to_expected(expected: UpdateSourceSnapshot,
                                                for sectionUpdates: [TableViewSectionUpdate] ,
                                                file: StaticString = #file,
                                                line: UInt = #line) {
        let snapshot = sourceToTest.update(with: sectionUpdates)
        XCTAssertEqual(expected,
                       snapshot,
                       file: file,
                       line: line)
        
    }
    
    func check_if_state_is_expected(_ expected: [SectionalMock<MockReusableCell>],
                                    file: StaticString = #file,
                                    line: UInt = #line) {
        XCTAssertEqual(typecastedSections,
                       expected,
                       file: file,
                       line: line)
    }
    
        
    private var typecastedSections: [SectionalMock<MockReusableCell>] {
        sourceToTest.sections as? [SectionalMock<MockReusableCell>] ??
            sourceToTest.sections.compactMap({ $0 as? TableViewSection })
                                 .map(SectionalMock<MockReusableCell>.init)
                        
    }
}


extension SectionUpdateSnapshot: Equatable {
    public static func == (lhs: SectionUpdateSnapshot,
                    rhs: SectionUpdateSnapshot) -> Bool {

         return  lhs.indexesSnapshot == rhs.indexesSnapshot
    
    }
}


extension UpdateSourceSnapshot: Equatable {
    public static func == (lhs: UpdateSourceSnapshot,
                    rhs: UpdateSourceSnapshot) -> Bool {
        return lhs.sectionSnapshots == rhs.sectionSnapshots
    }

}


extension SectionSourceTester {
    struct TestCaseConfig {
           let sectionID: String
           let section: SectionalMock<MockReusableCell>
           let snapshot: SectionUpdateSnapshot
           let changes: [TableViewSectionUpdate]
    }
}


extension SectionSourceTester {
  func createTestAdditionConfig(sectionNumber: Int, rowNames: [String]) -> TestCaseConfig {
        let id = "section\(sectionNumber)"
        let expectedSection = factory.defaultSection(with: id, rowNames: rowNames)
        let sectionAdditionsUpdates =  sectionAdditions(for: id, names: rowNames)
        let additionIndexes = setsOfIndexes(for: 0, numberOfRows: rowNames.count)
        let indexSnapshot = IndexesSnapshot<IndexPath>(inserted: additionIndexes)
        let sectionOneSnapshot = SectionUpdateSnapshot(section: expectedSection,
                                                       indexesSnapshot: indexSnapshot)
        return TestCaseConfig(sectionID: id,
                              section: expectedSection,
                              snapshot: sectionOneSnapshot,
                              changes: sectionAdditionsUpdates)
    }
     
    func createTestUpdateConfig(sectionNumber: Int, rowNames: [String]) -> TestCaseConfig {
        let id = "section\(sectionNumber)"
        let expectedSection = factory.defaultSection(with: id, rowNames: rowNames)
        let sectionAdditionsUpdates =  sectionUpdates(for: id, names: rowNames)
        let updateIndexes = setsOfIndexes(for: 0, numberOfRows: rowNames.count)
        let indexSnapshot = IndexesSnapshot<IndexPath>(updated: updateIndexes)
        let sectionOneSnapshot = SectionUpdateSnapshot(section: expectedSection,
                                                       indexesSnapshot: indexSnapshot)
        return TestCaseConfig(sectionID: id,
                              section: expectedSection,
                              snapshot: sectionOneSnapshot,
                              changes: sectionAdditionsUpdates)
    }

    func createTestDeleteConfig(sectionNumber: Int, rowNames: [String]) -> TestCaseConfig {
        let id = "section\(sectionNumber)"
        let expectedSection = factory.defaultSection(with: id, rowNames: rowNames)
        let sectionAdditionsUpdates =  sectionUpdates(for: id, names: rowNames)
        let removedIndexes = setsOfIndexes(for: 0, numberOfRows: rowNames.count)
        let indexSnapshot = IndexesSnapshot<IndexPath>(removed: removedIndexes)
        let sectionOneSnapshot = SectionUpdateSnapshot(section: expectedSection,
                                                                     indexesSnapshot: indexSnapshot)
        return TestCaseConfig(sectionID: id,
                              section: expectedSection,
                              snapshot: sectionOneSnapshot,
                              changes: sectionAdditionsUpdates)
    }
    
    
    var defaultSection: SectionalMock<MockReusableCell> {
        initialSection(with: defaultSectionID)
    }

    func initialSection(with id: String) -> SectionalMock<MockReusableCell> {
        factory.initialSection(with: id)
    }

    var defaultUpdatedSection: SectionalMock<MockReusableCell> {
        defaultSectionUpdated(for: defaultSectionID)
    }

    func defaultSectionUpdated(for sectionID: String) -> SectionalMock<MockReusableCell> {
        factory.defaultSectionUpdated(withID: sectionID)
    }

    func sectionUpdates(for sectionID: String, names: [String]) -> [TableViewSectionUpdate]  {
        factory.defaultSectionUpdates(withID: sectionID, newNames: names)
    }

    func sectionAdditions(for sectionID: String, names: [String]) -> [TableViewSectionUpdate]  {
        factory.defaultSectionAdditions(withID: sectionID, newNames: names)
    }

    func defaultSectionSnapshot(for sectionID: String) -> SectionUpdateSnapshot {
       SectionUpdateSnapshot(section: defaultSectionUpdated(for: sectionID))
    }
    
    func setsOfIndexes(for section: Int, numberOfRows: Int) -> [IndexPath] {
         stride(from: 0,
                to: numberOfRows,
                by: 1).map({ IndexPath(row: $0, section: section) })
     }
}
