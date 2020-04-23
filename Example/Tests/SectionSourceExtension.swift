//
//  SectionSourceExtension.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource


extension SectionUpdateSnapshot {
    func updated(inserted: [IndexPath]) -> Self {
        Self(section: section,
             indexesSnapshot: indexesSnapshot.updated(inserted: inserted))
    }
    
    func updated(removed: [IndexPath]) -> Self {
        Self(section: section,
             indexesSnapshot: indexesSnapshot.updated(removed: removed))
    }
    
    func updated(updated: [IndexPath]) -> Self {
        Self(section: section,
             indexesSnapshot: indexesSnapshot.updated(updated: updated))
    }
}

extension IndexesSnapshot {
    func updated(inserted: [T]) -> Self {
        .init(inserted: inserted,
              updated: updated,
              removed: removed)
    }
    
    func updated(updated: [T]) -> Self {
        .init(inserted: inserted,
             updated: updated,
             removed: removed)
    }
    
    func updated(removed: [T]) -> Self {
        .init(inserted: inserted,
              updated: updated,
              removed: removed)
    }
}
