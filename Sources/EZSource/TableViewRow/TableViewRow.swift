//
//  TableViewRow.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

import UIKit

/**
  The concept of a generic TableViewCell:
   - it knows about model it operates with
   - contains tap closure that is called when a cell is tapped
   - responsible for dequeueing a cell
   - provides methods to add leading / trailing actions
 
   **Example**
    - Define a Cell Model
 
    ````
    struct StringCellModel:  Hashable  {
        let uniqueID: String
        let text: String

        // Defines uniqueness of the model
        func hash(into hasher: inout Hasher) {
            hasher.combine(uniqueID)
        }

        // Defines dynamic context of the model
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.text == rhs.text
        }
    }
    ````
    - Define a Cell
 
    ````
    final class StringCell: UITableViewCell, ReusableCell, Configurable {
        typealias Model = StringCellModel
        let checkmarkView = UIView()

        func configure(with model: StringCellModel) {
            textLabel?.text = "ID: \(model.uniqueID): \(model.text)"
            selectionStyle = .none
        }

        override var isSelected: Bool {
            didSet {
                debugPrint(isSelected)
            }
        }

        override func prepareForReuse() {
            accessoryType = .none
        }

        override func setSelected(_ selected: Bool, animated: Bool) {

            if selected {
               accessoryType = .checkmark
            } else {
               accessoryType = .none
            }
            super.setSelected(selected, animated: animated)

        }
    }
    ````
 
    - create a `TableViewRow`
 
    ````
    let model = StringCellModel(uniqueID: ID, text: title)
    let row = TableViewRow<StringCell>(model: model,
                                       onTap: { debugPrint("tapped with \($0)")})
    // add rows if need
    row.addRowLeadingActions(leadingActions)
    row.addRowTrailingActions(trailingActions)
    ````
 */
public class TableViewRow<Cell>: CellProvider where Cell: Configurable & ReusableCell {

    /// Model that is used to configure the cell
    public var model: Cell.Model

    let onTap: ((Cell.Model) -> Void)?
    var traillingSwipeConfiguration: RowActionSwipeConfiguration
    var leadingSwipeConfiguration: RowActionSwipeConfiguration
    var isSelected: Bool = false

    /// Main constructor
    /// - Parameters:
    ///   - model: `Cell.Model`
    ///   - traillingSwipeConfiguration: `RowActionSwipeConfiguration`
    ///   - leadingSwipeConfiguration: `RowActionSwipeConfiguration`
    ///   - onTap: (Cell.Model) -> Void)
    ///
    /// - Note:
    ///     `traillingSwipeConfiguration` and `leadingSwipeConfiguration` are optional
    ///     arguments, you should use them  if you want to disable long swipe mode on the actions
    ///
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
        cell.setSelected(isSelected, animated: false)
        return cell
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
        let actions = config.actions.map({ $0.contextualAction })
        return .init(contextualActions: actions,
                     performFirstActionWithFullSwipe: config.performFirstActionWithFullSwipe)
    }
}

extension TableViewRow {

    /// Appends trailing actions for the row
    /// - Parameter actions: [`RowAction`]
    public func addRowTrailingActions(_ actions: [RowAction]) {
        traillingSwipeConfiguration.actions.append(contentsOf: actions)
    }

    /// appends leading actions for the row
    /// - Parameter actions: [`RowAction`]
    public func addRowLeadingActions(_ actions: [RowAction]) {
        leadingSwipeConfiguration.actions.append(contentsOf: actions)
    }
}

extension TableViewRow {

    /// Appends trailing actions for the row and returns Self. Usefull for chainig operation
    /// - Parameter actions: [`RowAction`]
    /// - Returns: Self
    public func addedRowTrailingActions(_ actions: [RowAction]) -> Self {
        addRowTrailingActions(actions)
        return self
    }

    /// Appends leading actions for the row and returns Self. Usefull for chainig operation
    /// - Parameter actions: [`RowAction`]
    /// - Returns: Self
    public func addedRowLeadingActions(_ actions: [RowAction]) -> Self {
        addRowLeadingActions(actions)
        return self
    }

    func selectRow(of tableView: UITableView, at indexPath: IndexPath) {
        selectTableViewRow(tableView, at: indexPath, select: isSelected)
        isSelected = !isSelected
    }

    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Self {
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

    /// Conformance to `Equatable` protocol.
    ///
    /// Note: Two rows are considered equal if their models are equal
    ///
    ///
    /// - Parameters:
    ///   - lhs: `TableViewRow<Cell>`
    ///   - rhs: `TableViewRow<Cell>`
    /// - Returns: Bool
    public static func == (lhs: TableViewRow, rhs: TableViewRow) -> Bool {
        lhs.model == rhs.model
    }

    /// Conformance to Hashable
    /// uses hash of the model
    /// - Parameter hasher: `Hasher`
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }

}
