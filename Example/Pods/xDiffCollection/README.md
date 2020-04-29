# xDiffCollection

[![Version](https://img.shields.io/cocoapods/v/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/xDiffCollection)
[![License](https://img.shields.io/cocoapods/l/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/xDiffCollection)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyCollection.svg?style=flat)](https://cocoapods.org/pods/xDiffCollection)

## Description
xDiffCollection operates on the concept of bins. A bin is an array and a filter. 
Elements that go in those bins are hashable identifiable and equatable differentiable.
The filter accepts elements into a bin based on a custom logic provided via a boolean closure.

xDiffCollection exposes two operations: update and delete (update can also add an element if the element passes the test and 
the element is not previously there)

If the element was already there and an update operation is performed, the logic in the bin is re-run to decide if this is 
still the appropriate bin for that updated element or not. If it is not, the element is deleted from the current bin and moved
to a bin where the updated element passes another's bin logic.

### Main Mutating Methods 
- `mutating func update(element:T) -> DiffCollectionResult`
- `mutating func delete(element:T) -> DiffCollectionResult`

### Element Accessing Methods
- `func element(atIndexPath path:IndexPath) -> T?`
- `func numberOfElements(inSection binIndex:Int) -> Int`
- `func numberOfSections() -> Int`

## Example
After installing xDiffCollection, just include it via:
```ruby
import xDiffCollection
```
Create some DiffCollectionFilters:
```ruby
let f1 = DiffCollectionFilter<TestObject>(name: "Starts with a", filter:{ s in
    if(s.value.starts(with: "a")) {
        return true
    }
    return false
})
        
let f2 = DiffCollectionFilter<TestObject>(name: "Starts with b", filter:{ s in
    if(s.value.starts(with: "b")) {
        return true
    }
    return false
})

let f3 = DiffCollectionFilter<TestObject>(name: "Starts with c", filter:{ s in
    if(s.value.starts(with: "c")) {
        return true
    }
    return false
})
```
Instanciate your collection using those filters:
```ruby
let myCollection = DiffCollection(filters: [f1,f2,f3])
```
And start using your collection:

```ruby
let result : DiffCollectionResult = myCollection.update(element: TestObject())
```
Where

```ruby
public struct DiffCollectionResult {
    public var deleted: [IndexPath]
    public var added: [IndexPath]
    public var updated: [IndexPath]
}
```
And IndexPath.section represents the storage bin in myCollection,
and IndexPath.row the position of an element within its bin. 

## Installation

xDiffCollection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'xDiffCollection'
```

## Author

ALDO Inc., aldodev@aldogroup.com

## License

xDiffCollection is available under the MIT license. See the LICENSE file for more info.
