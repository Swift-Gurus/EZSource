//
//  CollectionChanges.swift
//  xDiffCollection
//
//  Created by Alex Hmelevski on 2018-06-18.
//

import Foundation

public protocol CollectionUpdateResult {
    associatedtype Index
    var updatedIndexes: [Index] { get }
    var removedIndexes: [Index] { get }
    var addedIndexes: [Index] { get }
}


public struct CollectionChanges<T, C: Collection> where C.Element == T {
    public  let updatedIndexes: C
    public let removedIndexes: C
    public let addedIndexes: C
    public typealias Index = T
    
    public init(updatedIndexes: C,
                removedIndexes: C,
                addedIndexes: C) {
        self.updatedIndexes = updatedIndexes
        self.addedIndexes = addedIndexes
        self.removedIndexes = removedIndexes
    }
}

public extension CollectionChanges where C: RangeReplaceableCollection, C.Element == T {

     init(updatedIndexes: C = C(),
          removedIndexes: C = C(),
          addedIndexes: C = C()) {
        self.updatedIndexes = updatedIndexes
        self.addedIndexes = addedIndexes
        self.removedIndexes = removedIndexes
    }
}

