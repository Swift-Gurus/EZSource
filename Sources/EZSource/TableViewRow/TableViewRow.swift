//
//  TableViewRow.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

protocol CellProvider: TappableCell,CellDequeuer,CellActionsProvider, Selectable { }

struct CellActionSwipeConfiguration {
    let contextualActions: [UIContextualAction]
    let performFirstActionWithFullSwipe: Bool
}

protocol CellActionsProvider {
    var trailingActionSwipeConfiguration: CellActionSwipeConfiguration { get }
    var leadingActionSwipeConfiguration: CellActionSwipeConfiguration { get }
}

protocol TappableCell {
   func didTap()
}

protocol Selectable {
    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Self
    func selectRow(of tableView: UITableView, at indexPath: IndexPath)
}

protocol CellDequeuer {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) throws -> UITableViewCell
}

public struct RowActionSwipeConfiguration {
    public var actions: [RowAction]
    public let performFirstActionWithFullSwipe: Bool

    public init(actions: [RowAction] = [],
                performFirstActionWithFullSwipe: Bool = true) {
        self.actions = actions
        self.performFirstActionWithFullSwipe = performFirstActionWithFullSwipe
    }
    
   public static var empty: RowActionSwipeConfiguration {
        RowActionSwipeConfiguration()
    }
}

public class TableViewRow<Cell>: CellProvider where Cell: Configurable & ReusableCell  {
    public var model: Cell.Model
    let onTap: ((Cell.Model) -> Void)?
    public var traillingSwipeConfiguration: RowActionSwipeConfiguration
    public var leadingSwipeConfiguration: RowActionSwipeConfiguration
    var isSelected: Bool = false
    
    public init(model: Cell.Model,
                traillingSwipeConfiguration: RowActionSwipeConfiguration = .empty ,
                leadingSwipeConfiguration: RowActionSwipeConfiguration = .empty,
                onTap: ((Cell.Model) -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
        self.traillingSwipeConfiguration = traillingSwipeConfiguration
        self.leadingSwipeConfiguration = leadingSwipeConfiguration
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
    
    var trailingActionSwipeConfiguration: CellActionSwipeConfiguration {
        return getSwipeConfiguration(fromRowActionSwipeConfig: traillingSwipeConfiguration)
    }
    
    var leadingActionSwipeConfiguration: CellActionSwipeConfiguration {
        return getSwipeConfiguration(fromRowActionSwipeConfig: leadingSwipeConfiguration)
    }

    private func getSwipeConfiguration(fromRowActionSwipeConfig config: RowActionSwipeConfiguration) -> CellActionSwipeConfiguration {
        return CellActionSwipeConfiguration(contextualActions: config.actions.map({ $0.contextualAction }),
                                            performFirstActionWithFullSwipe: config.performFirstActionWithFullSwipe)
    }
    
}


// MARK: - Mutating Methods
extension TableViewRow {
    
    public func addRowTrailingActions(_ actions: [RowAction]) {
        traillingSwipeConfiguration.actions.append(contentsOf: actions)
    }
    
    public func addRowLeadingActions(_ actions: [RowAction]) {
        leadingSwipeConfiguration.actions.append(contentsOf: actions)
    }
}


// MARK: - Immutable Methods
extension TableViewRow {
    
    public func addedRowTrailingActions(_ actions: [RowAction]) -> Self {
        addRowTrailingActions(actions)
        return self
    }
    
    public func addedRowLeadingActions(_ actions: [RowAction]) -> Self {
        addRowLeadingActions(actions)
        return self
    }
    
    public func selectRow(of tableView: UITableView, at indexPath: IndexPath) {
        selectTableViewRow(tableView, at: indexPath, select: isSelected)
        isSelected = !isSelected
    }
    
    public func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Self {
        selectTableViewRow(tableView, at: indexPath, select: isSelected)
        isSelected = !isSelected
        return self
    }
    
    private func selectTableViewRow(_ tableView: UITableView, at indexPath: IndexPath, select: Bool) {
        if select {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
}

extension TableViewRow: Hashable, Equatable where Cell.Model: Hashable & Equatable {
    public static func == (lhs: TableViewRow<Cell>, rhs: TableViewRow<Cell>) -> Bool {
        lhs.model == rhs.model
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
    
}

