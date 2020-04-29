//
//  HeaderFooterProvider.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

public protocol SectionHeaderFooterProvider  {
    var title: String? { get }
    var height: CGFloat? { get }
    func headerView(forTableView: UITableView) -> UIView?
}

public class HeaderFooterProvider<View>: SectionHeaderFooterProvider where View: Configurable & ReusableView {
    public var title: String?
    
    let model: View.Model
    public let height: CGFloat?
    
    public init(model: View.Model, height: CGFloat? = nil) {
        self.model = model
        self.height = height
    }
    
    public func headerView(forTableView tableView: UITableView) -> UIView? {
       fatalError("\(self) SUBLCASSES SHOULD OVERRIDE")
    }
}

public class ImmutableHeaderFooterProvider<View>: HeaderFooterProvider<View> where View: Configurable & ReusableView  {
    
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        let view: View = tableView.dequeueView()
        view.configure(with: model)
        return view.uiView
    }
}

public class MutableHeaderFooterProvider<View>: HeaderFooterProvider<View> where View: Configurable & ReusableView {
    
    private var _cachedView: View?
    private var _lastModel: View.Model?
    
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        guard _cachedView == nil else { return _cachedView?.uiView }
        let view: View = tableView.dequeueView()
        view.configure(with: _lastModel ?? model)
        _cachedView = view
        return view.uiView
    }
    
    public func update(withModel model: View.Model) {
        _lastModel = model
        _cachedView?.configure(with: model)
    }
}



