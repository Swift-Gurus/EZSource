//
//  DiffableDataSourceTester.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import EZSource

final class DiffableDataSourceTester {
    typealias SectionUpdates = GenericSectionUpdate<AnyHashable, SectionTypeMock>
    typealias Result = DiffableDataSource.SourceUpdate<AnyHashable, SectionTypeMock>
    typealias SectionResult = DiffableDataSource.SectionUpdate<AnyHashable, SectionTypeMock>
    var sourceToTest: DiffableDataSource
    let factory = FilterProviderMock()
    
    init() {
        sourceToTest = DiffableDataSource(provider: factory.allPassedProvider)
    }
    
    func emulateUpdate(model: TextModelMock, type: SectionTypeMock) {
        let updates = sectionUpdate(for: type, models: [model])
        let _ = sourceToTest.update(using: [updates])
    }
    
    func getConfig(request: CaseConfigRequest) -> CaseConfig {
        let updates = sectionUpdate(for: request.section, models: [request.model])
        var sectionUpdate = expectedSectionUpdateResult(for: request.model,
                                                        sectionType: request.section)
        
        sectionUpdate = sectionUpdate.updated(insertedIndexes: request.insertedIndexes)
                                     .updated(updatedIndexes: request.updatedIndexes)
                                     .updated(removedIndexes: request.removedIndexes)
        let result = expectedSectionUpdateResult(with: [sectionUpdate])
        return CaseConfig(updatesSectionUpdates: updates, expectedResult: result)
    }

  
    func check_updates_for_models(models: [SectionUpdates],
                                  expectedResut: Result,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
        
        let result = sourceToTest.update(using: models)
        
        XCTAssertEqual(result,
                       expectedResut,
                       file: file,
                       line: line)
    }
}


extension DiffableDataSourceTester {
    
      private func expectedSectionUpdateResult(with updates: [SectionResult]) -> Result {
        .init(insertedIndexes: [], sectionUpdates: updates)
      }

      private func expectedSectionUpdateResult(for model: TextModelMock,
                                               sectionType: SectionTypeMock) -> SectionResult {
          .init(insertedIndexes: [],
                removedIndexes: [],
                updatedIndexes: [],
                model: AnyHashable(model),
                id: sectionType)
      }

      private func sectionUpdate(for sectionType: SectionTypeMock,
                                 models: [TextModelMock]) -> SectionUpdates {
          let changes = DiffableDataSourceTester.SectionUpdates(id: .section1)
          models.map(AnyHashable.init)
                .forEach({ changes.rows.append($0) })
          return changes
      }
      
    
    struct CaseConfig {
        let updatesSectionUpdates: SectionUpdates
        let expectedResult: Result
    }
    
    
    struct CaseConfigRequest {
        var insertedIndexes: [IndexPath] = []
        var removedIndexes: [IndexPath] = []
        var updatedIndexes: [IndexPath] = []
        let model: TextModelMock
        let section: SectionTypeMock
        
        init(model: TextModelMock,
             section: SectionTypeMock) {
            self.model = model
            self.section = section
        }
    }
}


