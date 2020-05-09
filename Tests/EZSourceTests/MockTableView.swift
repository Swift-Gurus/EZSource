//
//  MockTableView.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
@testable import EZSource

final class MockTableView: UITableView {
    
    private(set) var cellIDs: [String] = []
    private(set) var dequeuedCellIDs: [String] = []
    private(set) var reusableViewIDs: [String] = []
    private(set) var dequeuedReusableViewIDs: [String] = []
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.contentSize = frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        dequeuedCellIDs.append(identifier)
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    
    
    override func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        dequeuedReusableViewIDs.append(identifier)
        return super.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }
    
    
    override func register(_ cellClass: AnyClass?,
                           forCellReuseIdentifier identifier: String) {
        cellIDs.append(identifier)
        super.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        reusableViewIDs.append(identifier)
        super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
