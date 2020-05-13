//
//  TableViewDiffableSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-27.
//

import Foundation

/**
    Represents  changes proposed to a section
    **Example**
    - Define a Cell Model

    ````
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

    ````
    final class StringCell: UITableViewCell, ReusableCell, Configurable {
       typealias Model = StringCellModel

       func configure(with model: StringCellModel) {
           textLabel?.text = "ID: \(model.uniqueID): \(model.text)"
           selectionStyle = .none
       }
    }
    ````

    - create a `TableViewRow`

    ````
    let model = StringCellModel(uniqueID: ID, text: title)
    let row = TableViewRow<StringCell>(model: model,
                                      onTap: { debugPrint("tapped with \($0)")})
    // add rows if need
    row.addRowLeadingActions(leadingActions)
    row.addRowTrailingActions(trailingActions)
    ````
    - Add the row to the cell

    ````
    let updates = TableViewDiffableSection(id: "SectionID here")
    updates.addRows([row])
    ````
    - Create a ReusableView

    ````
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

    ````
    let text = "My custom section"
    let footer = ImmutableHeaderFooterProvider<TestReusableView>(model: text)
    ````

    - Attach the header to a `TableViewDiffableSection`

    ````
    let updates = TableViewDiffableSection(id: "SectionID here")
    updates.addHeader(header)
    ````
    
 */
public final class TableViewDiffableSection: GenericSectionUpdate<AnyHashable, String> {

    public var settings: Settings = .init()

    /**
        **Example**
        - Define a Cell Model

        ````
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

        ````
        final class StringCell: UITableViewCell, ReusableCell, Configurable {
            typealias Model = StringCellModel

            func configure(with model: StringCellModel) {
                textLabel?.text = "ID: \(model.uniqueID): \(model.text)"
                selectionStyle = .none
            }
        }
        ````

        - create a `TableViewRow`
     
        ````
        let model = StringCellModel(uniqueID: ID, text: title)
        let row = TableViewRow<StringCell>(model: model,
                                           onTap: { debugPrint("tapped with \($0)")})
        // add rows if need
        row.addRowLeadingActions(leadingActions)
        row.addRowTrailingActions(trailingActions)
        ````
        - Add the row to the cell
     
        ````
        let updates = TableViewDiffableSection(id: "SectionID here")
        updates.addRows([row])
        ````
        - Parameter rows: [`TableViewRow<Cell>`]
     */
    public func addRows<Cell>(_ rows: [TableViewRow<Cell>]) where Cell: Configurable & ReusableCell, Cell.Model: Hashable & Equatable {
        self.rows.append(contentsOf: rows.map(AnyHashable.init))
    }

    /**
      Method to add a header  to the section
    
       **Usage Example**

       - Create a ReusableView

       ````
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

       ````
       let text = "My custom section"
       let footer = ImmutableHeaderFooterProvider<TestReusableView>(model: text)
       ````

       - Attach the header to a `TableViewDiffableSection`

       ````
       let updates = TableViewDiffableSection(id: "SectionID here")
       updates.addHeader(header)
       ````
       - Parameter header: `HeaderFooterProvider<View>``
    */
    public func addHeader<View>(_ header: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        settings.headerProviderUpdate = .new(header)
    }

    /**
        Method to add a footer to the section
     
        **Usage Example**

        - Create a ReusableView

        ````
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

        ````
        let text = "My custom section"
        let footer = ImmutableHeaderFooterProvider<TestReusableView>(model: text)
        ````

        - Attach the header to a `TableViewDiffableSection`

        ````
        let updates = TableViewDiffableSection(id: "SectionID here")
        updates.addHeader(footer)
        ````
        - Parameter footer: `HeaderFooterProvider<View>``
     */

    public func addFooter<View>(_ footer: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        settings.footerProviderUpdate = .new(footer)
    }
}

extension TableViewDiffableSection {
    public enum HeaderFooterUpdate {
          case new(SectionHeaderFooterProvider)
          case reuse
          case empty
          case `default`
    }

    /**
        Provides settings for the sections like
        - row animations
        - section animations
        - header view provider
        - footer view provider
        - flag is the section is collapsed
     */
    public struct Settings {

        /// Row animations
        public var rowAnimationConfig = RowAnimationConfig()

        /// section animations
        public var sectionAnimationConfg = SectionAnimationConfig()

        /// header view provider update
        public var headerProviderUpdate: HeaderFooterUpdate = .reuse

        /// footer view provider update
        public var footerProviderUpdate: HeaderFooterUpdate = .reuse

        /// indicates if a section is collapsed or not
        public var collapsed: Bool = false
        var dynamic: Bool  = false
    }
}
