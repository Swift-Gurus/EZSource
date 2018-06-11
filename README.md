# EZSource

[![CI Status](https://img.shields.io/travis/AlexHmelevskiAG/EZSource.svg?style=flat)](https://travis-ci.org/AlexHmelevskiAG/EZSource)
[![Version](https://img.shields.io/cocoapods/v/EZSource.svg?style=flat)](https://cocoapods.org/pods/EZSource)
[![License](https://img.shields.io/cocoapods/l/EZSource.svg?style=flat)](https://cocoapods.org/pods/EZSource)
[![Platform](https://img.shields.io/cocoapods/p/EZSource.svg?style=flat)](https://cocoapods.org/pods/EZSource)


## Usage

- #### Cells 
Should conform to the protocols `ReusableCell` and `Configurable`. 
``` swift
final class StringCell: UITableViewCell, ReusableCell, Configurable {
typealias Model = String

func configure(with text: String) {
textLabel?.text = text
print(text)
}
}
```
- #### Source Initialization
```swift
let source = TableViewDataSource(tableView: tableView,
withTypes: [StringCell.self],
reusableViews: [])
```

- #### Create Rows
``` swift
var row = TableViewRow<String, StringCell>(model: "My Row")
```
- #### Add Rows to the section and call reload
Pass unique ID for every section if you use animated updates
``` swift
var section = TableViewSection(id: "Test")
section.addRows([row])
source.reload(with: [section])
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

EZSource is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EZSource'
```

## Author

ALDO Inc., aldodev@adogroup.com

## License

EZSource is available under the MIT license. See the LICENSE file for more info.
