# SwiftyCollection

[![CircleCI](https://circleci.com/gh/aldo-dev/SwiftyCollection.svg?style=svg)](https://circleci.com/gh/aldo-dev/SwiftyCollection)
[![Version](https://img.shields.io/cocoapods/v/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/SwiftyCollection)
[![License](https://img.shields.io/cocoapods/l/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/SwiftyCollection)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/SwiftyCollection)

## Desription
This library provides an extension to the family of Collection protocols (Collection, MutableCollection, and RangeReplacableCollection) for easier and range-safe access to its elements. Most of the added functions return optionals where `.none` is returned instead of conventional fatal error.

### Collection Methods 
- `func element(at index: Index) -> Element?`
- `func indexInBounds(_ index: Index) -> Bool` 

### Mutable RangeReplaceableCollection Collection Methods
- `mutating func removeLastSafe() -> SubSequence.Element?`
- `mutating func removeFirstSafe() -> SubSequence.Element?` 
- `mutating func replaceOccurrences(with element: Element, where predicate: (Element) -> Bool)` 
- `mutating func removeElement(where predicate: (Element) -> Bool) -> Self.Element?`

### Mutable RangeReplaceableCollection Collection Methods with Equatable Element
- `mutating func replaceOccurrences(of element: Element, with newElement: Element)`
- `mutating func removeElement(element: Element) -> Self.Element?`
- `mutating func removeElement(at index: Self.Index) -> Self.Element?`
- `mutating func removeDuplicates()`

### RangeReplaceableCollection 
The functions return a new collection
- `func removingLast() -> Self`
- `func removingFirst() -> Self`
- `func removingElement(where predicate: (Element) -> Bool) -> Self`
- `func replacingOccurrences(with newElement: Element, where predicate: (Element) -> Bool) -> Self`
- `func replacing(with newElement: Element, at index: Self.Index) -> Self`
- `func removing(at index: Self.Index) -> Self`

### RangeReplaceableCollection with Equatable Element
- `func removingElement(_ element: Element) -> Self`
- `func replacingOccurrences(of element: Element, with newElement: Element ) -> Self`
- `func removingDuplicates() -> Self`

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SwiftyCollection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyCollection'
```

## Author

ALDO Inc., aldodev@aldogroup.com

## License

SwiftyCollection is available under the MIT license. See the LICENSE file for more info.
