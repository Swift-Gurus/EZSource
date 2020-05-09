//
//  ComplexModelMock.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

struct Address: Equatable {
    let street: String
    let phone: String
    let country: String
}

struct ComplexModelMock: Hashable {
    let uniqueID: Int
    let address: Address
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.address == rhs.address
    }
}
