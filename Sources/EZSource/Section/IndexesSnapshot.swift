//
//  IndexesSnapshot.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-22.
//

import Foundation

struct IndexesSnapshot<T: Equatable>: Equatable {
    let inserted: [T]
    let updated: [T]
    let removed: [T]
    
    init(inserted: [T] = [],
         updated: [T] = [],
         removed: [T] = []) {
        self.inserted = inserted
        self.updated = updated
        self.removed = removed
    }
    
    func appended(inserted: T) -> Self {
        .init(inserted: self.inserted + [inserted],
              updated: updated,
              removed: removed)
    }
    
    func appended(updated: T) -> Self {
        .init(inserted: inserted,
              updated: self.updated + [updated],
              removed: removed)
    }
    
    func appended(removed: T) -> Self {
        .init(inserted: inserted,
              updated: updated,
              removed: self.removed + [removed])
    }
    
    func contains(_ element: T) -> Bool {
        inserted.contains(element) ||
        updated.contains(element) ||
        removed.contains(element)
    }
}
