//
//  MockReusableCell.swift
//  EZSource_Tests
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
@testable import EZSource

final class MockReusableCell: UITableViewCell, ReusableCell, Configurable {
    typealias Model = String
    
    private(set) var models: [String] = []
    func configure(with model: String) {
        models.append(model)
    }
}
