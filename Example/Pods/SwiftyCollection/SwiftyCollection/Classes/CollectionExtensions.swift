//
//  CollectionExtensions.swift
//  Pods
//
//  Created by Badreddine El Jamali on 2018-06-04.
//

import Foundation


public extension Collection {
    
    public func element(at index: Index) -> Element? {
        guard indexInBounds(index) else { return nil }
        return self[index]
    }
    
    public func indexInBounds(_ index: Index) -> Bool {
        return index < endIndex && index >= startIndex
    }
}
