//
//  StringCell.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-05.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import EZSource

struct StringCellModel: Hashable {
    let uniqueID: String
    let text: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.text == rhs.text
    }
}

final class StringCell: UITableViewCell, ReusableCell, Configurable {
    typealias Model = StringCellModel
    let checkmarkView = UIView()
    func configure(with model: StringCellModel) {
        textLabel?.text = "ID: \(model.uniqueID): \(model.text)"
        selectionStyle = .none
    }
    
    override var isSelected: Bool {
        didSet {
            debugPrint(isSelected)
        }
    }
    
    override func prepareForReuse() {
        accessoryType = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
           accessoryType = .checkmark
        } else {
           accessoryType = .none
        }
        super.setSelected(selected, animated: animated)
        
    }
    
}
