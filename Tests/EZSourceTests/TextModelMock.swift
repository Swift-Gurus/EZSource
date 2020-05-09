//
//  TextModelMock.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

enum SectionTypeMock: String {
    case section1
    case section2
    case section3
}


enum TextModelMockType: String {
    case type1
    case type2
    case type3
}

/// Type represent unique item
/// Text is something that is dynamic and can be changed
struct TextModelMock: Hashable {
    let text: String
    let type: TextModelMockType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.text == rhs.text
    }
    
}
