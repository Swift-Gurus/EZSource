//
//  SectionSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

class SectionSource {
    
    var sections: [Sectionable] = []
    var count: Int {
        return sections.count
    }
    
    init() {}
    func section(at index: Int) -> Sectionable {
        guard index < sections.count else {
            fatalError("Index OutOfBounds in \(self). Current count: \(count)")
        }
        return sections[index]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    func indexOfSection(_ section: Sectionable) -> Int? {
       return sections.enumerated().reduce(nil) { (part, elementEnumerated) -> Int? in
            return elementEnumerated.element.id == section.id ? elementEnumerated.offset : part
          
        }
    }
    
    func update(with sections: [Sectionable]) {
        guard !self.sections.isEmpty else {
            self.sections = sections
            return
        }
        sections.forEach({ self.replace(section: $0)})
    }
    
    func replace(section: Sectionable) {
        self.sections = self.sections.reduce([], { (partial, current) -> [Sectionable] in
            if current.id == section.id {
                return partial + [section]
            } else {
                return partial + [current]
            }
        })
    }
}
