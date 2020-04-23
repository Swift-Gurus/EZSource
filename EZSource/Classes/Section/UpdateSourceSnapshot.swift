//
//  UpdateSourceSnapshot.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-22.
//

import Foundation

struct UpdateSourceSnapshot {
    let sectionSnapshots: [SectionUpdateSnapshot]
    let indexesSnaphot: IndexesSnapshot<Int>
    
    init(sectionSnapshots: [SectionUpdateSnapshot],
         indexesSnaphot: IndexesSnapshot<Int> = .init() ) {
        self.sectionSnapshots = sectionSnapshots
        self.indexesSnaphot = indexesSnaphot
    }
    
    func updatedIndexesSnapshot(_ new: IndexesSnapshot<Int>) -> Self {
        .init(sectionSnapshots: sectionSnapshots,
              indexesSnaphot: indexesSnaphot)
    }
}
