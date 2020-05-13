//
//  TableViewSectionSettings.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-28.
//

import Foundation
#if !os(macOS)
import UIKit

struct TableViewSectionSettings {

    let id: String
    var headerProvider: SectionHeaderFooterProvider?
    var footerProvider: SectionHeaderFooterProvider?
    var collapsed: Bool = false
    var dynamic: Bool  = false
    var numberOfItems = -1
    var rowAnimationConfig = RowAnimationConfig()
    var sectionAnimationConfg = SectionAnimationConfig()

    init(id: String) {
        self.id = id
    }

    var headerHeight: CGFloat {
        getHeight(from: headerProvider)
    }

    var footerHeight: CGFloat {
        getHeight(from: footerProvider)
    }

    func headerView(for tableView: UITableView) -> UIView? {
        headerProvider.map({ (tableView, $0) })
                      .flatMap(getView)
    }

    func footerView(for tableView: UITableView) -> UIView? {
        footerProvider.map({ (tableView, $0) })
                      .flatMap(getView)
    }

    func deleteRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else { return }
        tableView.deleteRows(at: indexPaths, with: rowAnimationConfig.deleteAnimation)
    }

    func insertRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else { return }
        tableView.insertRows(at: indexPaths, with: rowAnimationConfig.insertAnimation)
    }

    func updateRows(in tableView: UITableView, at indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else { return }
        tableView.reloadRows(at: indexPaths, with: rowAnimationConfig.updateAnimation)
    }

    func insert(in tableView: UITableView, at indexSet: IndexSet) {
        tableView.insertSections(indexSet, with: sectionAnimationConfg.insertAnimation)
    }

    private func getHeight(from provider: SectionHeaderFooterProvider?) -> CGFloat {
        guard !shouldHideHeaderFooter else { return 0.1 }
        return provider.map { $0.height }
                       .map { $0  ?? UITableView.automaticDimension } ?? 0.1
    }

    private func getView(for tableView: UITableView,
                         using provider: SectionHeaderFooterProvider) -> UIView? {
       !shouldHideHeaderFooter ? provider.headerView(forTableView: tableView) : nil
    }

    private var shouldHideHeaderFooter: Bool {
        return (numberOfItems <= 0 && dynamic && !collapsed)
    }
}
#endif
