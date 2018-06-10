//
//  TableViewSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

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
    public mutating func addRows<T,C>(_ rows: [TableViewRow<T,C>]) where C: Configurable & ReusableCell, C.Model == T {
        self.rows.append(contentsOf: rows)
    }

    public mutating func addHeader<T,C>(_ header: HeaderFooterProvider<T,C>) where C: Configurable & ReusableView, C.Model == T {
        headerProvider = header
    }
    
    public mutating func addFooter<T,C>(_ footer: HeaderFooterProvider<T,C>) where C: Configurable & ReusableView, C.Model == T {
        footerProvider = footer
    }
}

// MARK: - Immutable Methods
extension TableViewSection {
    
    public func addedRows<T,C>(_ rows: [TableViewRow<T,C>]) -> TableViewSection where C: Configurable & ReusableCell, C.Model == T  {
        var newSection = TableViewSection(id: id)
        newSection.addRows(rows)
        return newSection
    }
    
    public func addedHeader<T,C>(_ header: HeaderFooterProvider<T,C>) -> TableViewSection where C: Configurable & ReusableView, C.Model == T {
        var currentSection = self
        currentSection.addHeader(header)
        return currentSection
    }
    
    public func addedFooter<T,C>(_ footer: HeaderFooterProvider<T,C>) -> TableViewSection where C: Configurable & ReusableView, C.Model == T {
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
        return try! rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    func headerView(forTableView tableView: UITableView) -> UIView? {
        return headerProvider?.headerView(forTableView: tableView)
    }
    
    func traillingActionsForRow(at index: Int) -> [UIContextualAction] {
        return rows[index].trailingContextualActions
    }
    
    func leadingActionsForRow(at index: Int) -> [UIContextualAction] {
        return rows[index].leadingContextualActions
    }
    
    func tapOnRow(at index: Int) {
        rows[index].didTap()
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
}


public protocol Identifiable {
    var id: String { get }
}

// MARK: - Sectionable
protocol Sectionable: Identifiable {
    var numberOfRows: Int { get }
    var headerProvider: SectionHeaderFooterProvider? { get }
    var footerProvider: SectionHeaderFooterProvider? { get }
    var collapsed: Bool { get }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func traillingActionsForRow(at index: Int) -> [UIContextualAction]
    func leadingActionsForRow(at index: Int) -> [UIContextualAction]
    func headerView(forTableView: UITableView) -> UIView?
    func tapOnRow(at index: Int)
}


// MARK: - AnimatableSection
public protocol AnimatableSection {
    var animationConfig: AnimationConfig { get }
    func deleteRows(in tableView: UITableView, at indexPaths: [IndexPath])
    func updateRows(in tableView: UITableView, at indexPaths: [IndexPath])
    func insertRows(in tableView: UITableView, at indexPaths: [IndexPath])
}


