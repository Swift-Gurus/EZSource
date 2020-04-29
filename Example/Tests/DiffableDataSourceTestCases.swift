//
//  DiffableDataSourceTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import EZSource

class DiffableDataSourceTestCases: XCTestCase {

    var tester = DiffableDataSourceTester()
    var mockText: String {
        tester.factory.baseText
    }
    
    var itemMoveText: String {
        tester.factory.sectionMoveText
    }
    typealias Request = DiffableDataSourceTester.CaseConfigRequest
    
    override func setUpWithError() throws {
        tester = DiffableDataSourceTester()
    }

    func test_new_items_are_added() {
        var request = getRequest(text: mockText, type: .type1, for: .section1)
        request.insertedIndexes = [IndexPath(row: 0, section: 0)]
        let caseConfig = tester.getConfig(request: request)
        tester.check_updates_for_models(models: [caseConfig.updatesSectionUpdates],
                                        expectedResut: caseConfig.expectedResult)

    }
    
    func test_item_is_updated() {
         // initial preparation
        let type: SectionTypeMock = .section1
        let uniqueID: TextModelMockType = .type1
        emulateInitialUpdate(text: mockText, type: uniqueID, for: type)
  
        var updateRequest = getRequest(text: mockText + "diff",
                                       type: uniqueID,
                                       for: type)
        
        updateRequest.updatedIndexes = [IndexPath(row: 0, section: 0)]
        let caseConfig = tester.getConfig(request: updateRequest)
        tester.check_updates_for_models(models: [caseConfig.updatesSectionUpdates],
                                        expectedResut: caseConfig.expectedResult)
    }
    
    func test_items_moved() {
        // initial preparation
        let type: SectionTypeMock = .section1
        let uniqueID: TextModelMockType = .type1
        emulateInitialUpdate(text: mockText,
                             type: .type1,
                             for: type)
        
        var updateRequest = getRequest(text: itemMoveText,
                                       type: uniqueID,
                                       for: type)
        updateRequest.removedIndexes = [IndexPath(row: 0, section: 0)]
        updateRequest.insertedIndexes = [IndexPath(row: 0, section: 2)]
        let caseConfig = tester.getConfig(request: updateRequest)
        
        tester.check_updates_for_models(models: [caseConfig.updatesSectionUpdates],
                                        expectedResut: caseConfig.expectedResult)
    }
    
    func test_section_is_added() {
        
    }
    
    func test_section_is_updated() {
        
    }
    
    func test_section_is_removed() {
        
    }
    
    private func getRequest(text: String,
                            type: TextModelMockType,
                            for sectionType: SectionTypeMock) -> Request {
        let mock = TextModelMock(text: text, type: type)
        return getRequest(model: mock, section: sectionType)
    }
    
    private func getRequest(model: TextModelMock,
                            section: SectionTypeMock) -> Request {
        .init(model: model,
              section: section)
    }

    private func emulateInitialUpdate(text: String,
                                      type: TextModelMockType,
                                      for sectionType: SectionTypeMock) {
        let mockModel = TextModelMock(text: text, type: type)
        tester.emulateUpdate(model: mockModel, type: sectionType)
    }
}


