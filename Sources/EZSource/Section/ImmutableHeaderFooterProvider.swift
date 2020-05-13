//
//  ImmutableHeaderFooterProvider.swift
//  
//
//  Created by Alex Hmelevski on 2020-05-12.
//

import Foundation
#if !os(macOS)
import UIKit

/**
    Default class that is responsible to dequeue a reusable view and configure it
 
    - Note:
         if the height is nil then you should make UIView as a self-sized view
 
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
    let header = ImmutableHeaderFooterProvider<TestReusableView>(model: text)
    ````
 
    - Attach the header to a `TableViewDiffableSection`
 
    ````
    let updates = TableViewDiffableSection(id: "SectionID here")
    updates.addHeader(header)
    ````
 */
public class ImmutableHeaderFooterProvider<View>: HeaderFooterProvider<View>
where View: Configurable & ReusableView {

    /// Returns configured view
    /// - Parameter tableView: `UITableView` used to dequeue the view
    /// - Returns: UIView?
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        let view: View = tableView.dequeueView()
        view.configure(with: model)
        return view
    }
}
#endif
