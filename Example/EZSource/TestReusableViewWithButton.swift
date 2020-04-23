//
//  TestReusableViewWithButton.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-05.
//  Copyright (c) 2018 AlexHmelevskiAG. All rights reserved.
//

import Foundation
import UIKit
import EZSource

public struct HeaderWithButtonModel {
    public let title: String
    public let buttonText: String
    public let tap: ()->Void
    public let collapsedText: String
    public init(title: String,
                buttonText: String,
                collapsedText: String,
                buttonTap: @escaping () -> Void) {
        self.title = title
        self.buttonText = buttonText
        self.tap = buttonTap
        self.collapsedText = collapsedText
    }
}



public final class TestReusableViewWithButton: UITableViewHeaderFooterView, ReusableView, Configurable {
    
    public typealias Model = HeaderWithButtonModel
    public  static var reuseIdentifier: String = "TestReusableViewWithButton"
    
    
    var label: UILabel!
    var button: UIButton!
    var tap: (()->Void)?
    override init(reuseIdentifier: String?) {
        print("Init")
        super.init(reuseIdentifier: reuseIdentifier)
        
        label = UILabel(frame: .zero)
        button = UIButton(frame: .zero)
        
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: label.rightAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        label.backgroundColor = .red
        label.numberOfLines = 0
        contentView.backgroundColor = .yellow
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public func configure(with model: HeaderWithButtonModel) {
        label.text = model.title
        button.setTitle(model.buttonText, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(callTap), for: .touchUpInside)
        button.setTitle(model.collapsedText, for: .selected)

        self.tap = model.tap
    }
    
    @objc func callTap() {
        debugPrint("TAPPING")
        button.isSelected = !button.isSelected
        tap?()
        
    }
}
