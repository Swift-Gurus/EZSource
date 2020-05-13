//
//  MutableHeaderFooterProvider.swift
//  
//
//  Created by Alex Hmelevski on 2020-05-12.
//

import Foundation
#if !os(macOS)
import UIKit

/**
    Default class that is responsible to dequeue a reusable view and configure it
    In addition provides an update method to change the model.
 
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
       // Store the header so you can reference to it later
       let header = MutableHeaderFooterProvider<TestReusableView>(model: text)
       ````
    
       - Attach the header to a `TableViewDiffableSection` and update after calling datasource update
    
       ````
       let updates = TableViewDiffableSection(id: "SectionID here")
       updates.addHeader(header)
       // call datasource update
       header.update(model: "New text here")
       ````
 */
public class MutableHeaderFooterProvider<View>: HeaderFooterProvider<View>
where View: Configurable & ReusableView {

    private var _cachedView: View?
    private var _lastModel: View.Model?

    /// Returns configured view
    ///
    /// - When a function is called for the first time it will create a view with a model and caches the view
    /// - For the next calls a cached view will be used
    /// - to update you should use `update(withModel model: View.Model)`
    ///
    /// - Parameter tableView: `UITableView` used to dequeue the view
    /// - Returns: UIView?
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        guard _cachedView == nil else { return _cachedView }
        let view: View = tableView.dequeueView()
        view.configure(with: _lastModel ?? model)
        _cachedView = view
        return view
    }

    /// Call the method to update the created view.
    ///
    /// - Note:
    ///   Calling this method before
    ///   `headerView(forTableView tableView: UITableView) -> UIView?`
    ///   has no effect since no view has been created
    ///
    /// - Parameter model: `View.Model`
    public func update(withModel model: View.Model) {
        _lastModel = model
        _cachedView?.configure(with: model)
    }
}
#endif
