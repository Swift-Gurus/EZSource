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
    
    func configure(with text: String) {
        textLabel?.text = text
        print(text)
    }
    
}
