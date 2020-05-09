//
//  SectionUpdateExtension.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource

extension DiffableDataSource.SectionUpdate where  T == AnyHashable, S == SectionTypeMock  {
    func updated(insertedIndexes: [IndexPath]) -> Self {
        .init(insertedIndexes: insertedIndexes,
              removedIndexes: removedIndexes,
              updatedIndexes: updatedIndexes,
              model: model,
              id: id)
    }
    
    func updated(removedIndexes: [IndexPath]) -> Self {
        .init(insertedIndexes: insertedIndexes,
              removedIndexes: removedIndexes,
              updatedIndexes: updatedIndexes,
              model: model,
              id: id)
    }
    
    func updated(updatedIndexes: [IndexPath]) -> Self {
        .init(insertedIndexes: insertedIndexes,
              removedIndexes: removedIndexes,
              updatedIndexes: updatedIndexes,
              model: model,
              id: id)
    }
    
    
    func updated(model: T) -> Self {
          .init(insertedIndexes: insertedIndexes,
                removedIndexes: removedIndexes,
                updatedIndexes: updatedIndexes,
                model: model,
                id: id)
    }
}
