//
//  TableViewRowProtocols.swift
//  
//
//  Created by Alex Hmelevski on 2020-05-11.
//

import Foundation
#if !os(macOS)
import UIKit

protocol CellProvider: TappableCell, CellDequeuer, CellActionsProvider, Selectable { }

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

#endif
