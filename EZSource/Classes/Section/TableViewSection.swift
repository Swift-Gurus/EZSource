//
//  TableViewSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit
import SwiftyCollection

public struct TableViewSection: Sectionable {

    public private(set) var id: String
    public var numberOfRows: Int { return collapsed ? 0 : rows.count }
    public var animationConfig: AnimationConfig = AnimationConfig()
    public var collapsed: Bool = false
    var headerProvider: SectionHeaderFooterProvider?
    var footerProvider: SectionHeaderFooterProvider?
    
    private(set) var rows: [CellProvider] = []
    
    public init(id: String) {
        self.id = id
    }
}


// MARK: - Mutating Methods
extension TableViewSection {
    public mutating func addRows<Cell>(_ rows: [TableViewRow<Cell>]) where Cell: Configurable & ReusableCell {
        self.rows.append(contentsOf: rows)
    }
    
    public mutating func addHeader<View>(_ header: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        headerProvider = header
    }
    
    public mutating func addFooter<View>(_ footer: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        footerProvider = footer
    }
}

// MARK: - Immutable Methods
extension TableViewSection {
    
    public func addedRows<Cell>(_ rows: [TableViewRow<Cell>]) -> TableViewSection where Cell: Configurable & ReusableCell {
        var newSection = TableViewSection(id: id)
        newSection.addRows(rows)
        return newSection
    }
    
    public func addedHeader<View>(_ header: HeaderFooterProvider<View>) -> TableViewSection where View: Configurable & ReusableView {
        var currentSection = self
        currentSection.addHeader(header)
        return currentSection
    }
    
    public func addedFooter<View>(_ footer: HeaderFooterProvider<View>) -> TableViewSection where View: Configurable & ReusableView {
        var currentSection = self
        currentSection.addFooter(footer)
        return currentSection
    }
    
    public func collapsedCopy(_ flag: Bool) -> TableViewSection {
        var section = self
        section.collapsed = flag
        return section
    }
}


// MARK: - Private Methods
extension TableViewSection {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rows.element(at: indexPath.row).flatMap({ try? $0.tableView(tableView, cellForRowAt: indexPath) }) else {
            let errorCell = UITableViewCell()
            errorCell.textLabel?.text = "Couldn't dequeue cell at indexPath: \(indexPath)"
            return errorCell
        }
        return cell
    }
    
    func headerView(forTableView tableView: UITableView) -> UIView? {
        return headerProvider?.headerView(forTableView: tableView)
    }
    
    func traillingActionsForRow(at index: Int) -> [UIContextualAction] {
        return rows.element(at: index)?.trailingActionSwipeConfiguration.contextualActions ?? []
    }
    
    func leadingActionsForRow(at index: Int) -> [UIContextualAction] {
        return rows.element(at: index)?.leadingActionSwipeConfiguration.contextualActions ?? []
    }
    
    func tapOnRow(at index: Int) {
        rows.element(at: index)?.didTap()
    }
    
    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Sectionable {
        var mSelf = self
        mSelf.rows = rows.enumerated().reduce([]) { (partial, element) -> [CellProvider] in
            if element.offset == indexPath.row {
                return partial + [element.element.selectingRow(of: tableView, at: indexPath)]
            } else {
               return partial + [element.element]
            }
            
        }
        return mSelf
    }
    
}


// MARK: - AnimatableSection
extension TableViewSection: AnimatableSection {
    public func deleteRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: animationConfig.deleteAnimation)
    }
    
    public func insertRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: animationConfig.insertAnimation)
    }
    
    public func updateRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: animationConfig.updateAnimation)
    }
    
    public func reload(in tableView: UITableView, at index: Int) {
        tableView.reloadSections([index], with: animationConfig.updateAnimation)
    }
    
    
    func expandCollapseSection(in tableView: UITableView, at index: Int) {
        collapsed ? collapseSection(in: tableView, at: index) : expandSection(in: tableView, at: index)
    }
    
    func expandSection(in tableView: UITableView, at index: Int) {
        tableView.insertRows(at: indexPaths(atIndex: index), with: animationConfig.expandAnimation)
    }
    
    func collapseSection(in tableView: UITableView, at index: Int) {
        tableView.deleteRows(at: indexPaths(atIndex: index), with: animationConfig.collapseAnimation)
    }
    
    private func indexPaths(atIndex index: Int) -> [IndexPath] {
        return rows.enumerated().map({ IndexPath(row: $0.offset, section: index) })
    }
    
    
    func updated(with cellItem: CellProvider?,
                 deletedIndex: Int? = nil,
                 updatedIndex: Int? = nil,
                 addedIndex: Int? = nil) -> TableViewSection {
        var mSelf = self
        mSelf.headerProvider = self.headerProvider
        mSelf.footerProvider = self.footerProvider
        
        if let deletedIndex = deletedIndex {
            mSelf.removeRow(at: deletedIndex)
        }
        
        if let updatedIndex = updatedIndex,
            let cellItem = cellItem {
            mSelf.update(cellItem, at: updatedIndex)
        }
        
        if let addedIndex = addedIndex,
            let cellItem = cellItem {
            mSelf.add(cellItem, at: addedIndex)
        }
        return mSelf
    }
    
    private mutating func removeRow(at index: Int) {
        guard index < rows.count else { return }
        rows.remove(at: index)
    }
    
    
    private mutating func update(_ cellItem: CellProvider, at index: Int) {
        guard index < rows.count else { return }
        rows[index] = cellItem
    }
    
    
    private mutating func add(_ cellItem: CellProvider, at index: Int) {
        guard index <= rows.count else { return }
        rows.insert(cellItem, at: index)
    }
    
}

public protocol Identifiable {
    var id: String { get }
}

// MARK: - Sectionable
protocol Sectionable: Identifiable {
    var numberOfRows: Int { get }
    var rows: [CellProvider] { get }
    var headerProvider: SectionHeaderFooterProvider? { get  set }
    var footerProvider: SectionHeaderFooterProvider? { get set }
    var collapsed: Bool { get }
    func collapsedCopy(_ flag: Bool) -> Self
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func traillingActionsForRow(at index: Int) -> [UIContextualAction]
    func leadingActionsForRow(at index: Int) -> [UIContextualAction]
    func headerView(forTableView: UITableView) -> UIView?
    func tapOnRow(at index: Int)
    func updated(with cellItem: CellProvider?,deletedIndex: Int?, updatedIndex: Int?, addedIndex: Int?) -> Self
    func expandCollapseSection(in tableView: UITableView, at index: Int)
    func selectingRow(of tableView: UITableView, at indexPath: IndexPath) -> Sectionable
    func reload(in tableView: UITableView, at index: Int) 
}

// MARK: - AnimatableSection
public protocol AnimatableSection {
    var animationConfig: AnimationConfig { get }
    func deleteRows(in tableView: UITableView, at indexPaths: [IndexPath])
    func updateRows(in tableView: UITableView, at indexPaths: [IndexPath])
    func insertRows(in tableView: UITableView, at indexPaths: [IndexPath])
  
}

