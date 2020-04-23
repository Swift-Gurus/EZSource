//
//  SectionUpdateSnapshot.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-22.
//

import Foundation

struct SectionUpdateSnapshot {

    let section: Sectionable & AnimatableSection
    let indexesSnapshot: IndexesSnapshot<IndexPath>
    
   
    init(section: Sectionable & AnimatableSection,
         indexesSnapshot: IndexesSnapshot<IndexPath> = .init()) {
        self.section = section
        self.indexesSnapshot = indexesSnapshot
    }
    
    func added(removed idx: IndexPath) -> Self {
        guard !indexesSnapshot.removed.contains(idx) else { return self }
        let result = section.updated(using: .delete(idx.row))
        let snapshot = result.1 ? indexesSnapshot.appended(removed: idx) : indexesSnapshot
        return .init(section: result.0,
                     indexesSnapshot: snapshot)
    }

    func added(updated element: CellProvider,at idx: IndexPath) -> Self {
        guard !indexesSnapshot.updated.contains(idx) else { return self }
        let result = section.updated(using: .update(idx.row,element))
        let snapshot = result.1 ? indexesSnapshot.appended(updated: idx) : indexesSnapshot
        return .init(section: result.0,
                     indexesSnapshot: snapshot)
    }

    func added(inserted element: CellProvider,at idx: IndexPath) -> Self {
        guard !indexesSnapshot.inserted.contains(idx) else { return self }
        let result = section.updated(using: .add(idx.row, element))
        let snapshot = result.1 ? indexesSnapshot.appended(inserted: idx) : indexesSnapshot
        return .init(section: result.0,
                     indexesSnapshot: snapshot)
    }
}
