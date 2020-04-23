//
//  SectionSourceTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-17.
//  Copyright (c) 2020 AlexHmelevskiAG. All rights reserved.
//

import XCTest
@testable import EZSource

class SectionSourceTestCases: XCTestCase {
    var tester = SectionSourceTester()
    private let defaultSectionID =  "defaultSection"
    var initalRowsNames = ["Row1","Row2", "Row2"]
    var updatedRowNames = ["UpdatedRow1","UpdatedRow2", "UpdatedRow2"]
    var secondSectionRowNames = ["S1", "S2", "S3"]
    override func setUpWithError() throws {
        tester = SectionSourceTester()
    }

    func test_source_first_update() {
        let expectedResult = [defaultSection]
        tester.emulateReload(using: expectedResult)
        tester.check_if_state_is_expected(expectedResult)
    }
    
    func test_updates_replaces_sections() {
        let expectedResult = [defaultUpdatedSection]
        tester.emulateReload(using: [defaultSection])
        tester.emulateReload(using: expectedResult)
        tester.check_if_state_is_expected(expectedResult)
    }
    
    func test_if_updates_are_applied_to_the_source() {
        let expectedResult = [defaultUpdatedSection]
        tester.emulateReload(using: [defaultSection])
        let updates = sectionUpdates(for: defaultSectionID, names: updatedRowNames)
        tester.emulateUpdates(using: updates)
        tester.check_if_state_is_expected(expectedResult)
    }
    
    
    func test_if_updates_are_created_section() {
        let expectedResult = [defaultSection]
        let updates = sectionAdditions(for: defaultSectionID, names: initalRowsNames)
        tester.emulateUpdates(using: updates)
        tester.check_if_state_is_expected(expectedResult)
    }
    
    func test_update_snapshot_contains_addition_indexes() {
        var sectionSnapshot = defaultSectionSnapshot(for: defaultSectionID)
        sectionSnapshot = sectionSnapshot.updated(inserted: defaultSetIndexes)
        let snapshot = UpdateSourceSnapshot(sectionSnapshots: [sectionSnapshot])
        let additions = sectionAdditions(for: defaultSectionID, names: updatedRowNames)
        tester.check_if_snapshot_is_equal_to_expected(expected: snapshot,
                                                      for: additions)
    }
    
    func test_update_snapshot_updates_rows() {
        let expectedResult = [defaultSection]
        tester.emulateReload(using: expectedResult)
        var sectionSnapshot = defaultSectionSnapshot(for: defaultSectionID)
        sectionSnapshot = sectionSnapshot.updated(updated: defaultSetIndexes)
        let snapshot = UpdateSourceSnapshot(sectionSnapshots: [sectionSnapshot])
        let updates = sectionUpdates(for: defaultSectionID, names: updatedRowNames)
        tester.check_if_snapshot_is_equal_to_expected(expected: snapshot,
                                                      for: updates)
    }
    
    func test_creates_two_sections() {
        let sectionOneRows = ["S1", "S2", "S3"]
        let configSectionOne = createTestAdditionConfig(sectionNumber: 0, rowNames: sectionOneRows)

        let sectionTwoRows = ["R1", "R2"]
        let configSectionTwo =  createTestAdditionConfig(sectionNumber: 1, rowNames: sectionTwoRows)
        let snapshots = [configSectionOne.snapshot, configSectionTwo.snapshot]
        let snapShotFirstUpdate = UpdateSourceSnapshot(sectionSnapshots: snapshots)
        let changesUnion = configSectionOne.changes + configSectionTwo.changes
        tester.check_if_snapshot_is_equal_to_expected(expected: snapShotFirstUpdate,
                                                      for: changesUnion)
        let expectedSections = [configSectionOne.section, configSectionTwo.section]
        tester.check_if_state_is_expected(expectedSections)
    }
    
    
    func test_updates_one_sections() {
        let sectionOneRows = ["S1", "S2", "S3"]
        let configSectionOne = createTestAdditionConfig(sectionNumber: 0, rowNames: sectionOneRows)

        let sectionTwoRows = ["R1", "R2"]
        let configSectionTwo =  createTestAdditionConfig(sectionNumber: 1, rowNames: sectionTwoRows)
        let snapshots = [configSectionOne.snapshot, configSectionTwo.snapshot]
        let snapShotFirstUpdate = UpdateSourceSnapshot(sectionSnapshots: snapshots)
        let changesUnion = configSectionOne.changes + configSectionTwo.changes
        tester.check_if_snapshot_is_equal_to_expected(expected: snapShotFirstUpdate,
                                                      for: changesUnion)
        
        let updateConfig = createTestUpdateConfig(sectionNumber: 1, rowNames: ["RR1", "RR2"])
        let updateSnapshot = [updateConfig.snapshot]
        let snapShotSecondUpdate = UpdateSourceSnapshot(sectionSnapshots: updateSnapshot)
        tester.check_if_snapshot_is_equal_to_expected(expected: snapShotSecondUpdate,
                                                      for: updateConfig.changes)
        
        let expectedSections = [configSectionOne.section, updateConfig.section]
        tester.check_if_state_is_expected(expectedSections)
    }
}


extension SectionSourceTestCases {
    var defaultSection: SectionalMock<MockReusableCell> {
        initialSection(with: defaultSectionID)
    }
    
    func initialSection(with id: String) -> SectionalMock<MockReusableCell> {
        tester.initialSection(with: id)
    }

    var defaultUpdatedSection: SectionalMock<MockReusableCell> {
        defaultSectionUpdated(for: defaultSectionID)
    }
    
    func defaultSectionUpdated(for sectionID: String) -> SectionalMock<MockReusableCell> {
        tester.factory.defaultSectionUpdated(withID: sectionID)
    }

    func sectionUpdates(for sectionID: String, names: [String]) -> [TableViewSectionUpdate]  {
        tester.factory.defaultSectionUpdates(withID: sectionID, newNames: names)
    }

    func sectionAdditions(for sectionID: String, names: [String]) -> [TableViewSectionUpdate]  {
        tester.factory.defaultSectionAdditions(withID: sectionID, newNames: names)
    }

    func defaultSectionSnapshot(for sectionID: String) -> SectionUpdateSnapshot {
        SectionUpdateSnapshot(section: defaultSectionUpdated(for: sectionID))
    }
    
    var defaultSetIndexes: [IndexPath] {
        stride(from: 0,
               to: defaultSection.rows.count,
               by: 1).map({ IndexPath(row: $0, section: 0) })
    }
   
    func createTestAdditionConfig(sectionNumber: Int,
                                  rowNames: [String]) -> SectionSourceTester.TestCaseConfig {
        tester.createTestAdditionConfig(sectionNumber: sectionNumber,
                                        rowNames: rowNames)
    }
     
    func createTestUpdateConfig(sectionNumber: Int,
                                rowNames: [String]) -> SectionSourceTester.TestCaseConfig {
        tester.createTestUpdateConfig(sectionNumber: sectionNumber,
                                      rowNames: rowNames)
    }

    func createTestDeleteConfig(sectionNumber: Int,
                                rowNames: [String]) -> SectionSourceTester.TestCaseConfig {
        tester.createTestDeleteConfig(sectionNumber: sectionNumber,
                                      rowNames: rowNames)
    }
    
    

}
