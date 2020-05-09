//
//  ReusableCell.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

public protocol Reusable {
    static var reuseID: String { get }
}

public extension Reusable {
    static var reuseID: String { return "\(self)"}
}


public protocol TableViewCell: class {
    var uiTableViewCell: UITableViewCell { get }
}


public protocol ReusableCell: TableViewCell, Reusable { }

public protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}
