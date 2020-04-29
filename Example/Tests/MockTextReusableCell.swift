//
//  MockTextReusableCell.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import EZSource

final class MockTextReusableCell: UITableViewCell, ReusableCell, Configurable {
    typealias Model = TextModelMock
    
    private(set) var models: [TextModelMock] = []
    func configure(with model: TextModelMock) {
        models.append(model)
    }
}
