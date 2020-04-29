//
//  TableViewDataSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

extension UISwipeActionsConfiguration {
    convenience init(actions: [UIContextualAction], longSwipe: Bool){
        self.init(actions: actions)
        self.performsFirstActionWithFullSwipe = longSwipe
    }
}

open class TableViewDataSource: NSObject  {
    
    var source = SectionSource()
    public var animationConfig = AnimationConfig()
    public var dynamicSections = false
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
    
    public func isSectionCollapsed(_ sectionID: String) -> Bool? {
        return source.indexOfSection(sectionID).map({ source.section(at: $0) })
                                               .map({ $0.collapsed })
    }
    
    public func reload(with sections: [TableViewSection]) {
        source.update(with: sections)
        tv.reloadData()
    }
    
    public func collapseSection(_ sectionID: String, collapse: Bool) {
        guard let index = source.indexOfSection(sectionID)else { return }
        tv.performBatchUpdates({[ weak self] in
            guard let `self` = self else { return }
            let new = source.sections[index].collapsedCopy(collapse)
            self.source.update(with: [new])
            new.expandCollapseSection(in: self.tv, at: index)
        }, completion: nil)
    }

    @available(*, deprecated)
    public func updateWithAnimation(updates: [UpdateInfo]) {
        guard !source.sections.isEmpty else {
            reload(with: updates.map({ $0.section }))
            return
        }
        
        guard !dynamicSections else {
            updateNoAnimation(updates: updates)
            return
        }
        
        tv.performBatchUpdates({[ weak self] in
            guard let `self` = self else { return }
            self.source.update(withInfo: updates)
            
            updates.filter({!$0.section.collapsed})
                   .forEach({ self.launchUpdates(in: self.tv, with: $0) })
            
        }, completion: nil)
    }
    
    @available(*, deprecated)
    public func updateNoAnimation(updates: [UpdateInfo]) {
        source.update(withInfo: updates)
        tv.reloadData()
    }
    
    private func launchUpdates(in tableView: UITableView, with info : UpdateInfo) {
    
        if !info.changes.deletedIndexes.isEmpty {
            info.section.deleteRows(in: tableView, at: info.changes.deletedIndexes)
        }
        
        if !info.changes.updatedIndexes.isEmpty {
            info.section.updateRows(in: tableView, at: info.changes.updatedIndexes)
        }
        
        if !info.changes.insertedIndexes.isEmpty {
            info.section.insertRows(in: tableView, at: info.changes.insertedIndexes)
        }
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
        let tvSection = source.section(at: section)
        guard !shouldHideHeaderFooter(for: tvSection) else { return nil }
        return tvSection.footerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tvSection = source.section(at: section)
        guard !shouldHideHeaderFooter(for: tvSection) else { return nil }
        return tvSection.headerProvider?.headerView(forTableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow(of: tableView, at: indexPath)
        source.section(at: indexPath.section).tapOnRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selectRow(of: tableView, at: indexPath)
            source.section(at: indexPath.section).tapOnRow(at: indexPath.row)
        }
    }
    
    private func selectRow(of tableView: UITableView, at indexPath: IndexPath) {
        let section = source.section(at: indexPath.section).selectingRow(of: tableView, at: indexPath)
        source.replace(section: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let tvSection = source.section(at: section)
        guard !shouldHideHeaderFooter(for: tvSection) else { return 0.1 }
        return tvSection.headerProvider
                        .map{ $0.height }
                        .map { $0  ?? UITableView.automaticDimension } ?? 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tvSection = source.section(at: section)
        guard !shouldHideHeaderFooter(for: tvSection) else { return 0.1 }
        return tvSection.footerProvider
                        .map{ $0.height }
                        .map { $0  ?? UITableView.automaticDimension } ?? 0.1
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        return source.section(at: indexPath.section)
                     .rows
                     .element(at: indexPath.row)
                     .flatMap({ $0.leadingActionSwipeConfiguration })
                     .map({ ($0.contextualActions, $0.performFirstActionWithFullSwipe) })
                     .map(UISwipeActionsConfiguration.init)
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return source.section(at: indexPath.section)
                     .rows
                     .element(at: indexPath.row)
                     .flatMap({ $0.trailingActionSwipeConfiguration })
                     .flatMap({ ($0.contextualActions, $0.performFirstActionWithFullSwipe )})
                     .map(UISwipeActionsConfiguration.init)
    }
    
    private func shouldHideHeaderFooter(for section: Sectionable) -> Bool {
        return (section.numberOfRows == 0 && dynamicSections && !section.collapsed)
    }
}


// MARK: - NEW API
extension TableViewDataSource {
    @available(*, deprecated)
    public func applyChanges(_ changes: [TableViewSectionUpdate]) {
               
       tv.performBatchUpdates({[weak self] in
           guard let `self` = self else { return }
           self.sourceUpdate(with: changes, for: self.tv)
                    
        }, completion: nil)
    }
    @available(*, deprecated)
    private func sourceUpdate(with changes: [TableViewSectionUpdate], for tableView: UITableView)  {
        let snapShot = source.update(with: changes)
        processSectionUpdates(in: tableView, snapshot: snapShot.indexesSnaphot)
        
        snapShot.sectionSnapshots
                .enumerated()
                .filter({ !snapShot.indexesSnaphot.contains($0.offset) })
                .map({ $0.element})
                .forEach({ launchUpdates(in: tableView, with: $0) })
    }
    
    
    private func processSectionUpdates(in tableView: UITableView,
                                       snapshot: IndexesSnapshot<Int>) {
        if !snapshot.removed.isEmpty {
            tableView.deleteSections(IndexSet(snapshot.removed),
                                     with: animationConfig.deleteAnimation)
        }
        
        if !snapshot.updated.isEmpty {
            tableView.reloadSections(IndexSet(snapshot.updated),
                                     with: animationConfig.updateAnimation)
        }
        
        if !snapshot.inserted.isEmpty {
            tableView.insertSections(IndexSet(snapshot.inserted),
                                     with: animationConfig.insertAnimation)
        }
    }

    private func launchUpdates(in tableView: UITableView,
                               with snapshot: SectionUpdateSnapshot) {
        let indexesSnapshot = snapshot.indexesSnapshot
        
        if !indexesSnapshot.removed.isEmpty {
            snapshot.section.deleteRows(in: tableView, at: indexesSnapshot.removed)
         }
         
         if !indexesSnapshot.updated.isEmpty {
             snapshot.section.updateRows(in: tableView, at: indexesSnapshot.updated)
         }
         
         if !indexesSnapshot.inserted.isEmpty {
             snapshot.section.insertRows(in: tableView, at: indexesSnapshot.inserted)
         }
     }
}


