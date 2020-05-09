//
//  DiffableTableViewDataSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-27.
//

import Foundation

import UIKit

public final class DiffableTableViewDataSource: DiffableDataSource {
    typealias SectionUpdates = DiffableDataSource.SectionUpdate<AnyHashable,String>
    typealias SourceUpdates = DiffableDataSource.SourceUpdate<AnyHashable,String>
    var sectionSettings: [TableViewSectionSettings] = []
    var tableView: UITableView

    public required init(config: Config) {
        tableView = config.tableView
        super.init(provider: config.provider)
        tableView.dataSource = self
        tableView.delegate = self
        config.cellTypes.forEach(tableView.register)
        config.headerFooters.forEach(tableView.registerFooterHeader)
    }
    
    public func update(sections: [TableViewDiffableSection]) {
        performBatchUpdate {
             let sourceUpdate = update(using: sections)
             self.updateSettings(using: sections)
             self.launchUpdates(for: sourceUpdate)
        }
    }
    
    public func autoCollapseExpandSection(with id: String) {
        guard let sectionIndex = sectionIndex(for: id),
                var section = sectionSettings.element(at: sectionIndex) else { return }
    
        section.collapsed = !section.collapsed
        
        replaceSettings(with: section)
        let count = numberOfElements(for: id)
        let rowsPaths = stride(from: 0, to: count , by: 1).map({ IndexPath(row: $0, section: sectionIndex) })
        performAutoCollapseExpand(with: rowsPaths,
                                  collapsed: section.collapsed,
                                  config: section.sectionAnimationConfg)

    }
    
    private func performBatchUpdate(function: () -> Void ) {
        tableView.performBatchUpdates({
            function()
        }, completion: nil)
    }
    
    private func performAutoCollapseExpand(with paths: [IndexPath],
                                           collapsed: Bool,
                                           config: SectionAnimationConfig) {
        let function: ([IndexPath], UITableView.RowAnimation) -> Void
        function = collapsed ? tableView.deleteRows : tableView.insertRows
        let animation = collapsed ? config.collapseAnimation : config.expandAnimation
        performBatchUpdate {
            function(paths,animation)
        }
    }
    
    func launchUpdates(for sourceUpdate: SourceUpdates) {
        if sourceUpdate.insertedIndexes.isEmpty {
            sourceUpdate.sectionUpdates.forEach({ lunchUpdates(changes: $0) })
        } else {
            insertSections(sourceUpdate.insertedIndexes)
        }
    }
   
    func insertSections(_ indexes: [Int]) {
        indexes.forEach({ sectionSettings.element(at: $0)?.insert(in: tableView, at: [$0]) })
    }

    func lunchUpdates(changes: SectionUpdates) {
        
        guard let section = sectionSettings(with: changes.id),
                !section.collapsed else {
            return
        }
        
        let shouldUpdateOnly =  !movedItems(for: changes)
        
        animateRowUpdates(in: section,
                          shouldChangeNumberOfItems: shouldUpdateOnly,
                          for: changes)
    }
    
    private func updateSettings(using sections: [TableViewDiffableSection]) {
        sections.map(convertToSettings).forEach(replaceSettings)
    }
    
    private func replaceSettings(with settings: TableViewSectionSettings) {
        if sectionSettings.contains(where: { $0.id == settings.id }) {
            sectionSettings.replaceOccurrences(with: settings, where: { $0.id == settings.id})
        } else {
            sectionSettings.append(settings)
        }
    }
    
    private func convertToSettings(_ section: TableViewDiffableSection) -> TableViewSectionSettings {
        var settings = TableViewSectionSettings(id: section.id)
        let sectionSettings = section.settings
        settings.collapsed = sectionSettings.collapsed
        settings.dynamic = sectionSettings.dynamic
        settings.rowAnimationConfig = sectionSettings.rowAnimationConfig
        settings.sectionAnimationConfg = sectionSettings.sectionAnimationConfg
        settings.numberOfItems = numberOfElements(for: section.id)
        settings.headerProvider = getProvider(from: sectionSettings.headerProviderUpdate,
                                              footer: false,
                                              for: section.id)
        
        settings.footerProvider = getProvider(from: sectionSettings.footerProviderUpdate,
                                              footer: true,
                                              for: section.id)
        return settings
    }
    
    func getProvider(from viewUpdate: TableViewDiffableSection.HeaderFooterUpdate,
                     footer: Bool,
                     for id: String) -> SectionHeaderFooterProvider? {
        switch viewUpdate {
        case .empty:
            return nil
        case let .new(provider):
            return provider
        case .default:
            return DefatultHeaderFooterProvider()
        case .reuse:
            return getCurrentProvider(for: id, footer: footer)
        }
    }
    
    private func getCurrentProvider(for id: String,  footer: Bool) -> SectionHeaderFooterProvider? {
        guard let sec = sectionSettings(with: id) else { return nil }
        return footer ? sec.footerProvider : sec.headerProvider
    }
    
    private func sectionSettings(with id: String) -> TableViewSectionSettings? {
        sectionSettings.first(where: { $0.id == id })
    }
    
    private func numberOfElements(for sectionID: String) -> Int {
        sectionIndex(for: sectionID).map(numberOfElements) ?? -1
    }
    
    private func sectionIndex(for id: String) -> Int? {
        sectionSettings.firstIndex(where: {  $0.id == id })
    }
    
    private func movedItems(for changes:  DiffableDataSource.SectionUpdate<AnyHashable,String>) -> Bool {
        guard changes.insertedIndexes.count == 1 && changes.removedIndexes.count == 1 else {
            return false
        }
        tableView.moveRow(at: changes.removedIndexes[0], to: changes.insertedIndexes[0])
        return true
    }
    
    private func animateRowUpdates(in section: TableViewSectionSettings,
                                   shouldChangeNumberOfItems: Bool,
                                   for changes: DiffableDataSource.SectionUpdate<AnyHashable,String>) {
        if shouldChangeNumberOfItems {
            section.deleteRows(in: tableView, at: changes.removedIndexes)
            section.insertRows(in: tableView, at: changes.insertedIndexes)
        }
        section.updateRows(in: tableView, at: changes.updatedIndexes)
    }
}


extension DiffableTableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collapsed = sectionSettings.element(at: section)?.collapsed ?? false
        return !collapsed ? numberOfElements(at: section) : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        row(at: indexPath).flatMap({ try? $0.tableView(tableView, cellForRowAt: indexPath)})
                           ?? errorCell(at: indexPath)
    }
    
    private func errorCell(at indexPath: IndexPath) -> UITableViewCell {
        let errorCell = UITableViewCell()
        errorCell.textLabel?.text = "Couldn't dequeue cell at indexPath: \(indexPath)"
        return errorCell
    }
}

extension DiffableTableViewDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       sectionSettings.element(at: section)?.footerView(for: tableView)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) ->
        UIView? {
        sectionSettings.element(at: section)?.headerView(for: tableView)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow(of: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       if tableView.allowsMultipleSelection {
           selectRow(of: tableView, at: indexPath)
       }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionSettings.element(at: section)?.headerHeight ?? 0.1
    }
       
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       sectionSettings.element(at: section)?.footerHeight ?? 0.1
    }
    
    private func selectRow(of tableView: UITableView, at indexPath: IndexPath) {
        guard let row = row(at: indexPath) else { return }
        row.selectRow(of: tableView, at: indexPath)
        row.didTap()
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        row(at: indexPath).map({ $0.leadingActionSwipeConfiguration })
                          .map(UISwipeActionsConfiguration.init)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       row(at: indexPath).map({ $0.trailingActionSwipeConfiguration })
                         .map(UISwipeActionsConfiguration.init)
    }

    private func row(at indexPath: IndexPath) -> CellProvider? {
        element(at: indexPath)
    }
}

extension DiffableTableViewDataSource {
    public struct Config {
        let tableView: UITableView
        let cellTypes: [ReusableCell.Type]
        let headerFooters: [ReusableView.Type]
        let provider: DiffableDataSourceFilterProvider
        
        public init(tableView: UITableView,
                    cellTypes: [ReusableCell.Type],
                    headerFooters: [ReusableView.Type],
                    provider: DiffableDataSourceFilterProvider = .init()) {
            self.tableView = tableView
            self.provider = provider
            self.headerFooters = headerFooters
            self.cellTypes = cellTypes
        }
    }
}

extension UISwipeActionsConfiguration {
    convenience init(config: CellActionSwipeConfiguration) {
        self.init(actions: config.contextualActions)
        performsFirstActionWithFullSwipe = config.performFirstActionWithFullSwipe
    }
}

