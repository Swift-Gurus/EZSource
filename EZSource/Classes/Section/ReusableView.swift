//
//  ReusableView.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

public protocol AnyView: class {
    var uiView: UIView { get }
}

public protocol ReusableView: AnyView, Reusable { }
