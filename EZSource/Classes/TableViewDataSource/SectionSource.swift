//
//  SectionSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import SwiftyCollection

class SectionSource {
    
    var sections: [Sectionable] = []
    var count: Int { return sections.count }
    
    var isEmpty: Bool {
        return sections.map({$0.numberOfRows }).reduce(0, { $0 + $1 }) <= 0
    }
    
    init() {}
    func section(at index: Int) -> Sectionable {
        guard index < sections.count else {
            fatalError("Index OutOfBounds in \(self). Current count: \(count)")
        }
        return sections[index]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections.element(at: section)?.numberOfRows ?? 0
    }
    
    func indexOfSection(_ section: Sectionable) -> Int? {
        return sections.index(where: { $0.id == section.id })
    }
    
    func update(with sections: [Sectionable]) {
        guard !self.sections.isEmpty else {
            self.sections = sections
            return
        }
        
        sections.forEach({ self.replace(section: $0)})
    }
    
    
    public func update(withInfo info: [SectionUpdateInfo]) {
        guard !self.sections.isEmpty else {
            self.sections = info.map({$0.section})
            return
        }
        sections = sections.map({self.updateSection($0, with: info)})
    }
    
    func updateSection(_ section: Sectionable, with info: [SectionUpdateInfo]) -> Sectionable {
        guard let info = info.first(where: {$0.section.id == section.id }) else  { return section }
        
        return section.updated(with: info.section.rows.first,
                               deletedIndex: info.changes.deletedIndexes.first.map({ $0.row }),
                               updatedIndex: info.changes.updatedIndexes.first.map({ $0.row }),
                               addedIndex: info.changes.insertedIndexes.first.map({ $0.row }))
        
    }
    
    func replace(section: Sectionable) {
        self.sections = sections.replacingOccurrences(with: section, where: { $0.id == section.id })
    }
}
