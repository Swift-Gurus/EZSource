//
//  ReusableCell.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
import UIKit

/// The protocol that defines Unique Object
/// Any object that conforms to this protocol should provide a unique ID
/// By default `Reusable` has implementation that provides ID as an object name
public protocol Reusable {
    static var reuseID: String { get }
}

/// Extension that provides default implemetation
/// that provides ID as an object name
public extension Reusable {
    static var reuseID: String { return "\(self)" }
}

/// Convenience typealias that specifies `UITableViewCell`
/// conforming to `Reusable` protocol
public typealias ReusableCell = UITableViewCell & Reusable

/// Generic protocol that requires to provide
/// `configure(with model: Model)` method
public protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}
