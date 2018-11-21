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


final class StringCell: UITableViewCell, ReusableCell, Configurable {
    typealias Model = String
    let checkmarkView = UIView()
    func configure(with text: String) {
        textLabel?.text = text
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
