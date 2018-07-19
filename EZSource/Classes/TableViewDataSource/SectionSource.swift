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
    
    init() {}
    func section(at index: Int) -> Sectionable {
        guard index < sections.count else {
            fatalError("Index OutOfBounds in \(self). Current count: \(count)")
        }
        return sections[index]
    }
    
    var isEmpty: Bool {
        return sections.map({ $0.numberOfRows }).reduce(0, { $0 + $1 }) == 0
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
    
    func replace(section: Sectionable) {
        self.sections = sections.replacingOccurrences(with: section, where: { $0.id == section.id })
    }
}
