//
//  UITableViewExtension.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T>(at indexPath: IndexPath)  -> T where  T : ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unexpected ReusableCell Type for reuseID \(T.reuseID)")
        }
        return cell
    }
    
    func dequeueView<T>()-> T where  T : ReusableView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("Unexpected ReusableView Type for reuseID \(T.reuseID)")
        }
        return cell
    }
    
    func register(reusableCellType: ReusableCell.Type) {
        register(reusableCellType, forCellReuseIdentifier: reusableCellType.reuseID)
    }
    
    func registerFooterHeader(reusableViewType: ReusableView.Type) {
        register(reusableViewType, forHeaderFooterViewReuseIdentifier: reusableViewType.reuseID)
    }
}

