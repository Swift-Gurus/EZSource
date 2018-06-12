//
//  UITableViewExtension.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

enum TableViewError: Error {
    case wrongCellType(expectedType: String)
    case wrongViewType(expectedType: String)
    
}

extension UITableView {
    func dequeueCell<T>(at indexPath: IndexPath) throws -> T where  T : ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            throw TableViewError.wrongCellType(expectedType: "\(T.self)")
        }
        return cell
    }
    
    func dequeueView<T>() throws -> T where  T : ReusableView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            throw TableViewError.wrongViewType(expectedType: "\(T.self)")
        }
        return cell
    }
    
    
    func register(reusableCellType: ReusableCell.Type) {
        register(reusableCellType, forCellReuseIdentifier: reusableCellType.reuseIdentifier)
    }
    
    func registerFooterHeader(reusableViewType: ReusableView.Type) {
        register(reusableViewType, forHeaderFooterViewReuseIdentifier: reusableViewType.reuseIdentifier)
    }
}
