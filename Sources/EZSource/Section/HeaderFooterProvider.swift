//
//  HeaderFooterProvider.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
#if !os(macOS)
import UIKit

/**
    The methods adopted by the object you use to manage provide information
    about the table view header or footer
 
    - Note:
        if the height is nil then you should make UIView as a self-sized view
        
 */
public protocol SectionHeaderFooterProvider {
    var height: CGFloat? { get }
    func headerView(forTableView: UITableView) -> UIView?
}

/**
    The absctract class to provide  a section header or footer view
 
    **Warning**:
 
    Using this class as is will cause a **CRASH**
 */
public class HeaderFooterProvider<View>: SectionHeaderFooterProvider
where View: Configurable & ReusableView {

    let model: View.Model
    public let height: CGFloat?

    /// Constructor
    ///
    ///  The model is passed here should be used
    ///  to configure the `View`
    ///
    /// - Parameters:
    ///   - model: View.Model
    ///   - height: CGFloat?
    public init(model: View.Model,
                height: CGFloat? = nil) {
        self.model = model
        self.height = height
    }

    /// Returns a configured `UIView` or nil
    ///
    /// - Note:
    ///   Subclasses *must* implement this method
    ///
    /// - Parameter tableView: `UITableView`
    /// - Returns: `UIView`?
    public func headerView(forTableView tableView: UITableView) -> UIView? {
       fatalError("\(self) SUBLCASSES SHOULD OVERRIDE")
    }
}

#endif
