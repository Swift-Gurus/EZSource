//
//  MutableCollectionExtensions.swift
//  Pods-SwiftyCollection_Example
//
//  Created by Alex Hmelevski on 2018-06-11.
//

import Foundation


extension MutableCollection where Self: RangeReplaceableCollection {
    
    @discardableResult
    public mutating func removeLastSafe() -> SubSequence.Element? {
        let copy = self
        self = copy.removingLast()
        return copy.element(at: endIndex)
    }
    
    @discardableResult
    public mutating func removeFirstSafe() -> SubSequence.Element? {
        let copy = self
        self = copy.removingFirst()
        return copy.element(at: copy.startIndex)
    }
    
    public mutating func replaceOccurrences(with element: Element,
                                            where predicate: (Element) -> Bool) {
        
        self = self.replacingOccurrences(with: element, where: predicate)
    }
    
    @discardableResult
    public mutating func removeElement(where predicate: (Element) -> Bool) -> Self.Element? {
        guard let index = index(where: predicate) else { return nil }
        return remove(at: index)
    }
}


extension MutableCollection where Self: RangeReplaceableCollection, Element: Equatable {
    
    public mutating func replaceOccurrences(of element: Element, with newElement: Element) {
        replaceOccurrences(with: newElement, where: { $0 == element })
    }
    
    @discardableResult
    public mutating func removeElement(element: Element) -> Self.Element? {
        return removeElement(where: { $0 == element })
    }
    
    @discardableResult
    public mutating func removeElement(at index: Self.Index) -> Self.Element? {
        guard indexInBounds(index) else { return nil }
        return remove(at: index)
    }
    
    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
