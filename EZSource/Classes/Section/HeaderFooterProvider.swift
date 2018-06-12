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

public struct HeaderFooterProvider<T,C>: SectionHeaderFooterProvider where C: Configurable & ReusableView, C.Model == T  {
    var title: String?
    
    let model: T
    let height: CGFloat?
    
    public init(model: T, height: CGFloat? = nil) {
        self.model = model
        self.height = height
    }
    
    public func headerView(forTableView tableView: UITableView) -> UIView? {
        let view: C = tableView.dequeueView()
        view.configure(with: model)
        return view.uiView
    }
    
}




