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
var row = TableViewRow<StringCell>(model: "My Row")
```
- #### Creating TableViewSectionUpdate
   `TableViewSectionUpdate` provides API to config updates for different sections like animations, 
``` swift
var updates = TableViewSectionUpdate(sectionID: "\(0)")
updates.addAddOperation(row , at: IndexPath(row: 0, section: 0))
source.applyChanges([updates])
```

## Advanced Usage

#### Add Swipe actions to cells:
- ##### Create Action
```swift
		let action =  RowAction { [weak self] in
			guard let `self` = self else { return }
			let alertController = self.alertControllerExample
			let act = self.dismissAction(for: alertController)
			alertController.addAction(act)
			self.present(alertController, animated: true, completion: nil)
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
let header = ImmutableHeaderFooterProvider<TestReusableView>(model: "Section with text labels")
let footer = ImmutableHeaderFooterProvider<TestReusableView>(model: "Footer with text labels")
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

Swift Gurus., alexei.hmelevski@gmail.com

## License

EZSource is available under the MIT license. See the LICENSE file for more info.

