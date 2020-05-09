//
//  UITableViewCellExtension.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

extension UITableViewCell: TableViewCell {
    public var uiTableViewCell: UITableViewCell { return self}
}


extension UITableViewHeaderFooterView: AnyView {
    public var uiView: UIView { return self }

}
