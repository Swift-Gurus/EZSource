//
//  FilterProviderMock.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource

final class FilterProviderMock {
    var baseText = "sectionDiffText"
    var sectionMoveText = "sectionMoveText"
    let filterProvider = DiffableDataSourceFilterProvider()
    var allPassedProvider: DiffableDataSourceFilterProvider {
        let provider = DiffableDataSourceFilterProvider()
        provider.addFilter(section1Filter)
        provider.addFilter(section2Filter)
        provider.addFilter(section3Filter)
        return provider
    }
}

extension FilterProviderMock {
    var section1Filter: DiffableDataSourceFilter<TextModelMock, SectionTypeMock> {
        let text = sectionMoveText
        return DiffableDataSourceFilter(id: .section1) { (model) -> Bool in
           model.text != text
        }
    }
    
    var section2Filter: DiffableDataSourceFilter<ComplexModelMock, SectionTypeMock> {
         DiffableDataSourceFilter(id: .section2)
    }
    
    var section3Filter: DiffableDataSourceFilter<TextModelMock, SectionTypeMock> {
        let text = sectionMoveText
        return DiffableDataSourceFilter(id: .section3) { (model) -> Bool in
            model.text == text
        }
    }
}
