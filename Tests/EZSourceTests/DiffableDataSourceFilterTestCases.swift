//
//  DiffableDataSourceFilterTestCases.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import xDiffCollection
@testable import EZSource

class DiffableDataSourceFilterTestCases: XCTestCase {

    typealias Comparison = (TextModelMock) -> Bool
    typealias Filter = DiffableDataSourceFilter<TextModelMock, String>
    typealias FilterModel = DiffableDataSourceFilter<TextModelMock, String>.FilterModel
    typealias InputModel = DiffableDataSourceFilter<TextModelMock, String>.Model

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_returns_true_if_matches() throws {
        let sectionID = "SectionID"
        let inputModel = self.inputModel(for: sectionID)
        let dFilter = diffFilter(id: sectionID) { (model) -> Bool in
            model.type == self.defaultModel.type
        }
        XCTAssertTrue(dFilter.filter(inputModel))
    }

    func test_returns_false() {
        let sectionID = "SectionID"
        let inputModel = self.inputModel(for: sectionID)
        let dFilter = diffFilter(id: sectionID) { (model) -> Bool in
            model.type == .type3
        }
        XCTAssertFalse(dFilter.filter(inputModel))
    }

    private var defaultModel: TextModelMock {
        TextModelMock(text: "Text", type: .type1)
    }

    private func inputModel(for sectionID: String) -> InputModel {
        return InputModel(sectionID: sectionID,
                          model: AnyHashable(defaultModel))
    }

    private func sectionFilter(id: String, comparison: @escaping Comparison) -> Filter {
        .init(id: id, filter: comparison)
    }

    private func diffFilter(id: String,
                            comparison: @escaping Comparison) ->  DiffCollectionFilter<AnyHashable> {
        let filter = sectionFilter(id: id, comparison: comparison)
        return filter.diffCollectionFilter
    }
}
