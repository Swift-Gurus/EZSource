//
//  HeaderFooterProvider.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

protocol SectionHeaderFooterProvider  {
    var title: String? { get }
    var height: CGFloat? { get }
    func headerView(forTableView: UITableView) -> UIView?
    
}


public class HeaderFooterProvider<T,C>: SectionHeaderFooterProvider where C: Configurable & ReusableView, C.Model == T  {
    var title: String?
    
    let model: T
    let height: CGFloat?
    
    public init(model: T, height: CGFloat? = nil) {
        self.model = model
        self.height = height
    }
    
    public func headerView(forTableView tableView: UITableView) -> UIView? {
       fatalError("\(self) SUBLCASSES SHOULD OVERRIDE")
    }
    
}

public class ImmutableHeaderFooterProvider<T,C>: HeaderFooterProvider<T,C> where C: Configurable & ReusableView, C.Model == T   {
    
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        let view: C = tableView.dequeueView()
        view.configure(with: model)
        return view.uiView
    }
    
}

public class MutableHeaderFooterProvider<T,C>: HeaderFooterProvider<T,C> where C: Configurable & ReusableView, C.Model == T  {
    
    private var _cachedView: C?
    private var _lastModel: T?
    public override func headerView(forTableView tableView: UITableView) -> UIView? {
        guard _cachedView == nil else { return   _cachedView?.uiView }
        
        let view: C = tableView.dequeueView()
        view.configure(with: _lastModel ?? model)
        _cachedView = view
        return view.uiView
    }
    
    public func update(withModel model: T) {
        _lastModel = model
        _cachedView?.configure(with: model)
    }
    
}



