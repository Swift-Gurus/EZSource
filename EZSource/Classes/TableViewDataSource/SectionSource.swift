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
    
    func sectionWithID(_ id: String) -> Sectionable? {
        return sections.first(where: { $0.id == id })
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections.element(at: section)?.numberOfRows ?? 0
    }
    
    func indexOfSection(_ sectionID: String) -> Int? {
        return sections.firstIndex(where: { $0.id == sectionID})
    }
    
    func update(with sections: [Sectionable & AnimatableSection]) {
        guard !self.sections.isEmpty else {
            self.sections = sections
            return
        }
        
        sections.forEach({ self.replace(section: $0)})
    }
    
    @available(*, deprecated)
    public func update(withInfo info: [SectionUpdateInfo]) {
        guard !self.sections.isEmpty else {
            self.sections = info.map({ $0.section })
            return
        }
        sections = sections.map({ self.updateSection($0, with: info) })
    }
    
    @available(*, deprecated)
    func updateSection(_ section: Sectionable, with info: [SectionUpdateInfo]) -> Sectionable & AnimatableSection {
        guard let info = info.first(where: { $0.section.id == section.id }) else  { return section }
        
        var newSection = section.updated(with: info.section.rows.first,
                                         deletedIndex: info.changes.deletedIndexes.first.map({ $0.row }),
                                         updatedIndex: info.changes.updatedIndexes.first.map({ $0.row }),
                                         addedIndex: info.changes.insertedIndexes.first.map({ $0.row }))

        newSection.footerProvider = info.section.footerProvider
        newSection.headerProvider = info.section.headerProvider
        return newSection
    }
    

    func replace(section: Sectionable) {
        self.sections = sections.replacingOccurrences(with: section, where: { $0.id == section.id })
    }
}

// MARK: - NEW API
extension SectionSource {
    @available(*, deprecated)
    func update(with sectionsUpdates: [TableViewSectionUpdate]) -> UpdateSourceSnapshot {
        let snapshots = sectionsUpdates.map(update)
        let indexesSnapshot = updateSource(with: snapshots)
        return UpdateSourceSnapshot(sectionSnapshots: snapshots, indexesSnaphot: indexesSnapshot)
    }
    @available(*, deprecated)
    private func update(using sectionUpdate: TableViewSectionUpdate) -> SectionUpdateSnapshot {
        var section = self.section(for: sectionUpdate)
        applyHeaderFooterChanges(sectionUpdate.headerProviderUpdate,
                                 appliedValue: { section.headerProvider = $0 })
        applyHeaderFooterChanges(sectionUpdate.footerProviderUpdate,
                                 appliedValue: { section.footerProvider = $0 })
        section = section.collapsedCopy(sectionUpdate.collapsed)
        let snapshot = SectionUpdateSnapshot(section: section)
        return sectionUpdate.operations.reduce(snapshot, applyOperation)
    }
    
    @available(*, deprecated)
    private func applyHeaderFooterChanges(_ changes: TableViewSectionUpdate.HeaderFooterUpdate,
                                          appliedValue: (SectionHeaderFooterProvider?) -> Void)  {
        switch changes {
        
        case .empty: appliedValue(nil)
        case let .new(obj): appliedValue(obj)
        case .default: appliedValue(DefatultHeaderFooterProvider())
        case .reuse: break
        }
    }
    
    private func updateSource(with snapshots: [SectionUpdateSnapshot]) -> IndexesSnapshot<Int> {
        var indexesSnapshot = IndexesSnapshot<Int>()
        if sections.isEmpty {
            let enumeration = snapshots.enumerated()
            indexesSnapshot = enumeration.map( {$0.offset })
                                         .reduce(indexesSnapshot, { $0.appended(inserted: $1) })
            sections = enumeration.map({ $0.element.section })
        } else {
            snapshots.map({ $0.section }).forEach(replace)
        }
        return indexesSnapshot
    }

    @available(*, deprecated)
    private func section(for sectionUpdate: TableViewSectionUpdate) -> Sectionable {
        return sections.first(where: { $0.id == sectionUpdate.id }) ?? TableViewSection(id: sectionUpdate.id)
    }
    
    @available(*, deprecated)
    private func applyOperation(to snapshot: SectionUpdateSnapshot,
                                operation: TableViewSectionUpdate.UpdateOperation) -> SectionUpdateSnapshot {
     
        switch operation {
        case let .add(indexPath, model):
            return snapshot.added(inserted: model, at: indexPath)
        case let .update(indexPath, model):
            return snapshot.added(updated: model, at: indexPath)
        case let .delete(indexPath):
            return snapshot.added(removed: indexPath)
        case .noRowUpdates:
            return snapshot
        }
    }
}
