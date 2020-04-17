# EZSource

[![Build Status](https://app.bitrise.io/app/d32979af27c37da9/status.svg?token=-IhedTB5j9wMx1S8cYLRaA&branch=master)](https://app.bitrise.io/app/d32979af27c37da9)
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
    }
}
```
- #### Source Initialization
```swift
let source = TableViewDataSource(tableView: tableView, withTypes: [StringCell.self], reusableViews: [])
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

## Advanced Usage

#### Add Swipe actions to cells:
- ##### Create Action
```swift
let action = RowAction { [weak self] in
    let alertController = UIAlertController(title: "Action", message: "Done", preferredStyle: .alert)
    let act = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        alertController.dismiss(animated: true, completion: nil)
    
    })
    alertController.addAction(act)
    self?.present(alertController, animated: true, completion: nil)
}
```
- ##### Add Action to the Row as tralling or leading
```swift
row.addRowLeadingActions([action])
row.addRowTrailingActions([action])
```
#### Add Headers/Footers to cells:
- ##### Create a ReusableView 
```swift
final class TestReusableView: UITableViewHeaderFooterView, ReusableView, Configurable {

    typealias Model = String

    func configure(with txt: String) {
        label.text = txt
    }
}
```
- ##### Create Header/Footer
```swift
let header = HeaderFooterProvider<String,TestReusableView>.init(model: "My String header")
```
- ##### Add Header/Footer
```swift
section.addHeader(header)
section.addFooter(footer)
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
