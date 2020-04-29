//
//  TableViewSectionUpdate.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-18.
//

import Foundation

@available(*, deprecated)
public struct TableViewSectionUpdate: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: TableViewSectionUpdate, rhs: TableViewSectionUpdate) -> Bool {
        return lhs.id == rhs.id &&
                lhs.collapsed == rhs.collapsed &&
                lhs.operations == rhs.operations
    }
    
    public private(set) var id: String
    public var collapsed: Bool = false
    public var headerProviderUpdate: HeaderFooterUpdate = .reuse
    public var footerProviderUpdate: HeaderFooterUpdate = .reuse
    
    var operations: [UpdateOperation] = []
    
    public init(sectionID: String) {
        self.id = sectionID
    }
    
    enum UpdateOperation: Equatable {
        static func == (lhs: TableViewSectionUpdate.UpdateOperation, rhs: TableViewSectionUpdate.UpdateOperation) -> Bool {
            switch (lhs, rhs) {
            case let (.delete(lIdx), .delete(rIdx)): return lIdx == rIdx
            case let (.update(lIdx, _), .update(rIdx, _)): return lIdx == rIdx
            case let (.add(lIdx, _ ), .add(rIdx, _)): return lIdx == rIdx
            case (.noRowUpdates, .noRowUpdates): return true
            default: return false
            }
        }
        
        case delete(IndexPath)
        case update(IndexPath, CellProvider)
        case add(IndexPath, CellProvider)
        case noRowUpdates
    }
}


// MARK: - Mutating Methods

extension TableViewSectionUpdate {
    public mutating func addUpdateOperation<Cell>(_ row: TableViewRow<Cell>, at indexPath: IndexPath) where Cell: Configurable & ReusableCell {
        self.operations.append(.update(indexPath, row))
    }
    
    public mutating func addAddOperation<Cell>(_ row: TableViewRow<Cell>, at indexPath: IndexPath) where Cell: Configurable & ReusableCell {
        self.operations.append(.add(indexPath, row))
    }
    
    public mutating func addDeleteOperation(at indexPath: IndexPath) {
        self.operations.append(.delete(indexPath))
    }
    
    public mutating func addHeader<View>(_ header: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        headerProviderUpdate = .new(header)
    }
    
    public mutating func addFooter<View>(_ footer: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        footerProviderUpdate = .new(footer)
    }

}

// MARK: - Immutable Methods
extension TableViewSectionUpdate {
    
    public func setUpdated<Cell>(_ row: TableViewRow<Cell>, at indexPath: IndexPath) -> TableViewSectionUpdate where Cell: Configurable & ReusableCell {
        var newSection = self
        newSection.addUpdateOperation(row, at: indexPath)
        return newSection
    }
    
    public func setAdded<Cell>(_ row: TableViewRow<Cell>, at indexPath: IndexPath) -> TableViewSectionUpdate where Cell: Configurable & ReusableCell {
        var newSection = self
        newSection.addAddOperation(row, at: indexPath)
        return newSection
    }
    
    public func setDeleted(at indexPath: IndexPath) -> TableViewSectionUpdate {
        var newSection = self
        newSection.addDeleteOperation(at: indexPath)
        return newSection
    }
    
    public func addedFooter<View>(_ footer: HeaderFooterProvider<View>) -> TableViewSectionUpdate where View: Configurable & ReusableView {
        var currentSection = self
        currentSection.addFooter(footer)
        return currentSection
    }
    
    public func collapsedCopy(_ flag: Bool) -> TableViewSectionUpdate {
        var section = self
        section.collapsed = flag
        return section
    }
}


extension TableViewSectionUpdate {
    public enum HeaderFooterUpdate {
        case new(SectionHeaderFooterProvider)
        case reuse
        case empty
        case `default`
    }
}
