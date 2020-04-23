//
//  SectionableFactoryMock.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2020-04-20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource


final class SectionableFactoryMock {
    
    func initialSection(with id: String) -> SectionalMock<MockReusableCell> {
        defaultSection(with: id, rowNames: initalRowsNames)
    }
    var initalRowsNames = ["Row1","Row2", "Row2"]
    
    
    var updatedRowNames = ["UpdatedRow1","UpdatedRow2", "UpdatedRow2"]
    
    private func defaultSection(withID id: String) -> SectionalMock<MockReusableCell> {
        SectionalMock(id: id)
    }
    
    func defaultSectionUpdated(withID id: String) -> SectionalMock<MockReusableCell> {
        defaultSection(with: id, rowNames: updatedRowNames)
    }
    
     func defaultSectionUpdates(withID id: String,newNames: [String]) -> [TableViewSectionUpdate]  {
        let updates = defaultSectionUpdates(withID: id, for: newNames) { (section, row, path) in
            section.addUpdateOperation(row, at: path)
        }
        return [updates]
    }
    
    func defaultSectionAdditions(withID id: String, newNames: [String]) -> [TableViewSectionUpdate] {
        let updates = defaultSectionUpdates(withID: id, for: newNames) { (section, row, path) in
            section.addAddOperation(row, at: path)
        }
        return [updates]
    }
    
    func sectionSetOfDeletes(withID id: String) -> Set<TableViewSectionUpdate> {
        let updates = defaultSectionUpdates(withID: id, for: []) { (section, _, path) in
            section.addDeleteOperation(at: path)
        }
        return [updates]
    }
    
    private typealias updateFunction = (inout TableViewSectionUpdate,
                                        TableViewRow<MockReusableCell>,
                                        IndexPath) -> Void
    
    private func defaultSectionUpdates(withID id: String,
                                       for rowNames: [String],
                                       sectionUpdateFunction: updateFunction) -> TableViewSectionUpdate {
        var sectionUpdates = TableViewSectionUpdate(sectionID: id)
        rows(from: rowNames).enumerated()
                            .map({ ($0.element, IndexPath(row: $0.offset, section: 0)) })
                            .forEach({ sectionUpdateFunction(&sectionUpdates, $0.0, $0.1) })
        return sectionUpdates
    }
    
    
    func defaultSection(with id: String,
                        rowNames: [String]) -> SectionalMock<MockReusableCell> {
        let section = defaultSection(withID: id)
        let newRows = rows(from: rowNames)
        section._wrapped = section._wrapped.addedRows(newRows)
        return section
    }
    
    func getSections(for ids: [String]) -> [TableViewSection] {
        ids.map({ TableViewSection(id: $0) })
    }
    
    func rows(from models: [String]) -> [TableViewRow<MockReusableCell>] {
        models.map({ TableViewRow(model: $0) } )
    }
}
