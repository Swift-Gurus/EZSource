//
//  TableViewRow.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

protocol CellProvider: TappableCell,CellDequeuer,CellActionsProvider ,Selectable { }

protocol CellActionsProvider {
    var trailingContextualActions: [UIContextualAction] { get }
    var leadingContextualActions: [UIContextualAction] { get }
}

protocol TappableCell {
   func didTap()
}

protocol Selectable {
    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Self
}

protocol CellDequeuer {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) throws -> UITableViewCell
}


public struct TableViewRow<Cell>: CellProvider where Cell: Configurable & ReusableCell  {
    
    let model: Cell.Model
    let onTap: ((Cell.Model) -> Void)?
    var traillingActions: [RowAction] = []
    var leadingActions: [RowAction] = []
    var isSelected: Bool = false
    public init(model: Cell.Model,
                traillingActions: [RowAction] = [],
                leadingActions: [RowAction] = [],
                onTap: ((Cell.Model) -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
        self.traillingActions = traillingActions
        self.leadingActions = leadingActions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) throws -> UITableViewCell {
        let cell: Cell = tableView.dequeueCell(at: indexPath)
        cell.configure(with: model)
        if isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        cell.uiTableViewCell.setSelected(isSelected, animated: false)
        return cell.uiTableViewCell
    }
    
    func didTap() {
        onTap?(model)
    }
    
    var trailingContextualActions: [UIContextualAction] {
        return traillingActions.map({ $0.contextualAction })
    }
    
    var leadingContextualActions: [UIContextualAction] {
        return leadingActions.map({ $0.contextualAction })
    }
    
}


// MARK: - Mutating Methods
extension TableViewRow {
    
    public mutating func addRowTrailingActions(_ actions: [RowAction]) {
        traillingActions.append(contentsOf: actions)
    }
    
    public mutating func addRowLeadingActions(_ actions: [RowAction]) {
        leadingActions.append(contentsOf: actions)
    }
}


// MARK: - Immutable Methods
extension TableViewRow {
    
    public func addedRowTrailingActions(_ actions: [RowAction]) -> TableViewRow {
        var mutable = self
        mutable.addRowTrailingActions(actions)
        return mutable
    }
    
    public func addedRowLeadingActions(_ actions: [RowAction]) -> TableViewRow {
        var mutable = self
        mutable.addRowLeadingActions(actions)
        return mutable
    }
    
    
    public func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> TableViewRow {
        var row = self
        selectTableViewRow(tableView, at: indexPath, select: row.isSelected)
        row.isSelected = !row.isSelected
        return row
    }
    
    private func selectTableViewRow(_ tableView: UITableView, at indexPath: IndexPath, select: Bool) {
        if select {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
}

