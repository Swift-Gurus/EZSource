//
//  TestReusableView.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-05.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import EZSource
final class TestReusableView: UITableViewHeaderFooterView, ReusableView, Configurable {
    
    typealias Model = String
    static var reuseIdentifier: String = "TestReusableView"
    
    var label: UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        label = UILabel(frame: .zero)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        label.backgroundColor = .red
        contentView.backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with txt: String) {
        label.text = txt
    }
}
