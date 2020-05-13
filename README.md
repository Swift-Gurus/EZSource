# EZSource

[![Build Status](https://app.bitrise.io/app/d32979af27c37da9/status.svg?token=-IhedTB5j9wMx1S8cYLRaA&branch=master)](https://app.bitrise.io/app/d32979af27c37da9)

[![License](https://img.shields.io/cocoapods/l/EZSource.svg?style=flat)](https://cocoapods.org/pods/EZSource)
[![Platform](https://img.shields.io/cocoapods/p/EZSource.svg?style=flat)](https://cocoapods.org/pods/EZSource)
[![Documentation](https://swift-gurus.github.io/EZSource/badge.svg)](https://swift-gurus.github.io/EZSource)

## Usage

   The core of `EZSource` for `UITableView`. Provides declarative API to work with `UITableView`
   All you need is to initialize the source, create rows, add them to section updates and call update function
   The rest is handled by `EZSource`, next time you have to update the `UITableView`, `EZSource`
   will find take care about inserting, deleting or reloading rows  using animation provided in the section updates


   **Usage Example**

   - Define a Cell Model

   ````swift
   struct StringCellModel:  Hashable  {
     let uniqueID: String
     let text: String

     // Defines uniqueness of the model
     func hash(into hasher: inout Hasher) {
         hasher.combine(uniqueID)
     }

     // Defines dynamic context of the model
     static func == (lhs: Self, rhs: Self) -> Bool {
         lhs.text == rhs.text
     }
   }
   ````
   - Define a Cell

   ````swift
   final class StringCell: UITableViewCell, ReusableCell, Configurable {
     typealias Model = StringCellModel

     func configure(with model: StringCellModel) {
         textLabel?.text = "ID: \(model.uniqueID): \(model.text)"
         selectionStyle = .none
     }
   }
   ````
   - Create Data Source

   ````swift
   let config = DiffableTableViewDataSource.Config(tableView: tableView,
                                                   cellTypes: [StringCell.self],
                                                   headerFooters: [TestReusableView.self])
   source = DiffableTableViewDataSource(config: config)
   ````

   - create a `TableViewRow`

   ````swift
   let model = StringCellModel(uniqueID: ID, text: title)
   let row = TableViewRow<StringCell>(model: model,
                                    onTap: { debugPrint("tapped with \($0)")})
   // add rows if need
   row.addRowLeadingActions(leadingActions)
   row.addRowTrailingActions(trailingActions)
   ````
   - Add the row to the cell

   ````swift
   let updates = TableViewDiffableSection(id: "SectionID here")
   updates.addRows([row])
   ````
   - Create a ReusableView

   ````swift
   final class TestReusableView: ReusableView, Configurable {
     
      let label: UILabel
      override init(reuseIdentifier: String?) {
          // Init and Configure UILabel

          super.init(reuseIdentifier: reuseIdentifier)
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
     
      func configure(with txt: String) {
          label.text = txt
      }
   }

   ````
   - Create a header

   ````swift
   let text = "My custom section"
   let footer = ImmutableHeaderFooterProvider<TestReusableView>(model: text)
   ````

   - Attach the header to a `TableViewDiffableSection`

   ````swift
   let updates = TableViewDiffableSection(id: "SectionID here")
   updates.addHeader(header)
   ````

   - Call updates on the source

   ````swift
   source.update(sections: [updates])
   ````


## Documentaion 
For more information check the [documentaion page](https://swift-gurus.github.io/EZSource/)

## Author

Swift Gurus., alexei.hmelevski@gmail.com

## License

EZSource is available under the MIT license. See the LICENSE file for more info.

