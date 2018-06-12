//
//  RangeReplaceableCollectionExtensions.swift
//  Pods-SwiftyCollection_Example
//
//  Created by Alex Hmelevski on 2018-06-11.
//

import Foundation

public extension RangeReplaceableCollection {
    
    public func removingLast() -> Self {
        return Self(dropLast())
    }
    
    public func removingFirst() -> Self {
        return Self(dropFirst())
    }
    
    public func removingElement(where predicate: (Element) -> Bool) -> Self {
        return filter({ !predicate($0) })
    }
    
    public func replacingOccurrences(with newElement: Element, where predicate: (Element) -> Bool) -> Self {
        return reduce(Self([])) { (partial, element) -> Self in
            predicate(element) ? partial + [newElement] : partial + [element]
        }

    }
    
    public func replacing(with newElement: Element, at index: Self.Index) -> Self {
        guard indexInBounds(index) else { return self }
        let range = Range<Self.Index>(uncheckedBounds: (lower: index, upper: self.index(after: index)))
        var mutated = self
        mutated.replaceSubrange(range, with: Self([newElement]))
        return mutated
    }
    
    public func removing(at index: Self.Index) -> Self {
        guard indexInBounds(index) else { return self }
        let range = Range<Self.Index>(uncheckedBounds: (lower: index, upper: self.index(after: index)))
        var mutated = self
        mutated.replaceSubrange(range, with: Self([]))
        return mutated
    }
    
}

public extension RangeReplaceableCollection where Element: Equatable {
    
    public func removingElement(_ element: Element) -> Self {
        return self.removingElement(where: { $0 == element})
    }
    
    public func replacingOccurrences(of element: Element, with newElement: Element ) -> Self  {
        return self.replacingOccurrences(with: newElement, where: { $0 == element })
    }
    
    public func removingDuplicates() -> Self {
        return  reduce(Self([])) { (partial, element) -> Self in
            !partial.contains(element) ? partial + [element] : partial
        }
    }
}
