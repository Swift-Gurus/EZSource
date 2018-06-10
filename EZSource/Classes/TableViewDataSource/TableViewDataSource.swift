//
//  TableViewDataSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

open class TableViewDataSource: NSObject  {
    
    var source = SectionSource()
    
    var tv: UITableView
    public init(tableView: UITableView,
                withTypes types: [ReusableCell.Type],
                reusableViews: [ReusableView.Type] = []) {
        tv = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        types.map({ (cellType: $0, id: $0.reuseID) })
            .forEach({ tableView.register($0.cellType, forCellReuseIdentifier: $0.id) })
        
        reusableViews.forEach({ tableView.registerFooterHeader(reusableViewType: $0) })
    }


    public func isSectionCollapsed(_ section: TableViewSection) -> Bool {
        return source.indexOfSection(section).map({ source.section(at: $0) })
                                             .map({$0.collapsed }) ?? false

    }
    
    public func reload(with sections: [TableViewSection]) {
        source.update(with: sections)
        tv.reloadData()
    }
    
    public func collapseSection(_ section: TableViewSection, collapse: Bool) {
        guard let index = source.indexOfSection(section) else { return }
        let new = section.collapsedCopy(collapse)
        source.update(with: [new])
        tv.performBatchUpdates({[ weak self] in
            guard let `self` = self else { return }
                new.expandCollapseSection(in: self.tv, at: index)
            }, completion: nil)
    }

    
    public func updateWithAnimation(updates: [UpdateInfo]) {
        source.update(with: updates.map({$0.section}))
        
        tv.performBatchUpdates({[ weak self] in
            guard let `self` = self else { return }
            updates.forEach({ self.launchUpdates(in: self.tv, with: $0) })
        }, completion: nil)
    }
    
    private func launchUpdates(in tableView: UITableView, with info : UpdateInfo) {
        info.section.deleteRows(in: tableView, at: info.changes.deletedIndexes)
        info.section.updateRows(in: tableView, at: info.changes.updatedIndexes)
        info.section.insertRows(in: tableView, at: info.changes.insertedIndexes)
    }
}


extension TableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return source.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  source.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return source.section(at: indexPath.section).tableView(tableView, cellForRowAt: indexPath)
    }
}

extension TableViewDataSource: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return source.section(at: section).footerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return source.section(at: section).headerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        source.section(at: indexPath.section).tapOnRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  source.section(at: section)
                      .headerProvider
                      .map{ $0.height }
                      .map { $0  ?? UITableViewAutomaticDimension } ?? 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return source.section(at: section)
                     .footerProvider
                     .map{ $0.height }
                     .map { $0  ?? UITableViewAutomaticDimension } ?? 0.1
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = source.section(at: indexPath.section).leadingActionsForRow(at: indexPath.row)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = source.section(at: indexPath.section).traillingActionsForRow(at: indexPath.row)
        return UISwipeActionsConfiguration(actions: actions)
    }
}
