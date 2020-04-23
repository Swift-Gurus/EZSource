//
//  SectionalMock.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-17.
//  Copyright (c) 2020 AlexHmelevskiAG. All rights reserved.
//

import Foundation
@testable import EZSource

final class SectionalMock<Cell: Configurable & ReusableCell>: Sectionable, Equatable, CustomDebugStringConvertible where Cell.Model: Equatable {
    var animationConfig: AnimationConfig = .init()


    var debugDescription: String {
        "\(type(of: self)): models: \(models)"
    }
    
    var _wrapped: TableViewSection
    let id: String
    var numberOfRows: Int { rows.count }
    
    var rows: [CellProvider] { _wrapped.rows }
    
    var headerProvider: SectionHeaderFooterProvider?
    
    var footerProvider: SectionHeaderFooterProvider?
    
    var collapsed: Bool = false
    
    
    var models: [Cell.Model] {
        rows.compactMap({ $0 as? TableViewRow<Cell> })
            .map({ $0.model })
    }
    
    
    public init(section: TableViewSection) {
        _wrapped = section
        id = section.id
    }
    
    public init(id: String) {
        self.id = id
        _wrapped = TableViewSection(id: id)
    }
    
    func collapsedCopy(_ flag: Bool) -> Self {
        collapsed = flag
        return self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _wrapped.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func traillingActionsForRow(at index: Int) -> [UIContextualAction] {
        return _wrapped.traillingActionsForRow(at: index)
    }
    
    func leadingActionsForRow(at index: Int) -> [UIContextualAction] {
        return _wrapped.leadingActionsForRow(at: index)
    }
    
    func headerView(forTableView: UITableView) -> UIView? {
       return _wrapped.headerView(forTableView: forTableView)
    }
    
    func tapOnRow(at index: Int) {
        _wrapped.tapOnRow(at: index)
    }
    
    func updated(with cellItem: CellProvider?, deletedIndex: Int?, updatedIndex: Int?, addedIndex: Int?) -> Self {
        _wrapped  = _wrapped.updated(with: cellItem,
                                     deletedIndex: deletedIndex,
                                     updatedIndex: updatedIndex,
                                     addedIndex: addedIndex)
        return self
    }
    
    func expandCollapseSection(in tableView: UITableView, at index: Int) {
        _wrapped.expandCollapseSection(in: tableView, at: index)
    }
    
    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Sectionable {
        guard let wrapped = _wrapped.selectingRow(of: tableView, at: indexPath) as? TableViewSection else {
            fatalError()
        }
        _wrapped  = wrapped
        return self
    }
    
    func reload(in tableView: UITableView, at index: Int) {
        _wrapped.reload(in: tableView, at: index)
    }
    
    func updated(using operation: UpdateOperation) -> (SectionalMock<Cell>, Bool) {
        let result = _wrapped.updated(using: operation)
        _wrapped  = result.0
        return (self, result.1)
    }

     
     static func == (lhs: SectionalMock<Cell>, rhs: SectionalMock<Cell>) -> Bool {
        return lhs.models == rhs.models
     }
    

    func deleteRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        _wrapped.deleteRows(in: tableView, at: indexPaths)
    }
    
    func updateRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        _wrapped.updateRows(in: tableView, at: indexPaths)
    }
    
    func insertRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        _wrapped.insertRows(in: tableView, at: indexPaths)
    }
}
