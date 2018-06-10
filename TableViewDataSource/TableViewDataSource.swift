//
//  TableViewDataSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

struct SectionSource {
    
    public var sections: [Sectionable] = []
    public var count: Int {
        return sections.count
    }
    
    public init() {}
    public func section(at: Int) throws -> Sectionable {
        return sections[at]
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    public mutating func update(with sections: [Sectionable]) {
        //        print("Before Updates", self.sections.map{$0.numberOfRows})
        guard !self.sections.isEmpty else {
            self.sections = sections
            return
        }
        sections.forEach({ self.replace(section: $0)})
        //         print("After Updates", self.sections.map{$0.numberOfRows})
        //         print("After Updates", self.sections)
    }
    
    mutating func replace(section: Sectionable) {
        self.sections = self.sections.reduce([], { (partial, current) -> [Sectionable] in
            if current.id == section.id {
                return partial + [section]
            } else {
                return partial + [current]
            }
        })
    }
}

open class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var source = SectionSource()
    
    var tv: UITableView
    public init(tableView: UITableView,
                withTypes types: [ReusableCell.Type],
                reusableViews: [ReusableView.Type] = []) {
        tv = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        types.map({ (cellType: $0, id: $0.reuseIdentifier) })
            .forEach({tableView.register($0.cellType, forCellReuseIdentifier: $0.id) })
        
        reusableViews.forEach({ tableView.registerFooterHeader(reusableViewType: $0) })
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return source.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return try! source.section(at: indexPath.section).tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return try! source.section(at: section).footerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return try! source.section(at: section).headerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! source.section(at: indexPath.section).tapOnRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return try! source.section(at: section).headerProvider.map{$0.height}.flatMap{$0}.map{ CGFloat($0) } ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return try! source.section(at: section).footerProvider.map{$0.height}.flatMap{$0}.map{ CGFloat($0) } ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = try! source.section(at: indexPath.section).traillingActionsForRow(at: indexPath.row)
        //        guard !actions.isEmpty else { return nil}
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    public func reload(with sections: [TableViewSection]) {
        source.update(with: sections)
        tv.reloadData()
    }
    
    
    public func updateWithAnimation(updates: [UpdateInfo]) {
        source.update(with: updates.map({$0.section}))
        
        tv.performBatchUpdates({[ weak self] in
            guard let `self` = self else { return }
            updates.forEach({ self.launchUpdates(in: tv, with: $0) })
            }, completion: nil)
    }
    
    
    private func launchUpdates(in tableView: UITableView, with info : UpdateInfo) {
        info.section.deleteRows(in: tableView, at: info.changes.deletedIndexes)
        info.section.updateRows(in: tableView, at: info.changes.updatedIndexes)
        info.section.insertRows(in: tableView, at: info.changes.insertedIndexes)
    }
}
