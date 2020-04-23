//
//  Sectionable.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-18.
//

import Foundation


// MARK: - Sectionable
protocol Sectionable: Identifiable, AnimatableSection {
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
    func updated(using operation: UpdateOperation) -> (Self, Bool)
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
