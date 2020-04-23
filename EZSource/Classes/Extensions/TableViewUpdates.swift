//
//  TableViewUpdates.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

protocol SectionUpdateInfo {
    var section: TableViewSection { get }
    var changes: TableViewUpdates { get }
}

public struct UpdateInfo: SectionUpdateInfo {
    public let section: TableViewSection
    public let changes: TableViewUpdates
    
    public init(section: TableViewSection,
                changes: TableViewUpdates) {
        self.section = section
        self.changes = changes
    }
}

public struct TableViewUpdates {
    public let deletedIndexes: [IndexPath]
    public let updatedIndexes: [IndexPath]
    public let insertedIndexes: [IndexPath]
    
    public init(deletedIndexes: [IndexPath] = [],
                updatedIndexes: [IndexPath] = [],
                insertedIndexes: [IndexPath] = []) {
        self.deletedIndexes = deletedIndexes
        self.updatedIndexes = updatedIndexes
        self.insertedIndexes = insertedIndexes
    }
}


extension TableViewUpdates {
    func added(deletedIndexes: [IndexPath]) -> Self {
        .init(deletedIndexes: self.deletedIndexes + deletedIndexes,
              updatedIndexes: updatedIndexes,
              insertedIndexes: insertedIndexes)
    }
    
    func added(updatedIndexes: [IndexPath]) -> Self {
        .init(deletedIndexes: deletedIndexes,
            updatedIndexes: self.updatedIndexes + updatedIndexes,
            insertedIndexes: insertedIndexes)
    }
    
    func added(insertedIndexes: [IndexPath]) -> Self {
        .init(deletedIndexes: deletedIndexes,
              updatedIndexes: updatedIndexes,
              insertedIndexes: self.insertedIndexes + insertedIndexes)
    }
}
