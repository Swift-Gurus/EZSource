//
//  SectionAnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-28.
//

import Foundation
#if !os(macOS)
import UIKit

/**
    The struct that allows you to configure animation for the section behaviour
 */
public struct SectionAnimationConfig {
    let deleteAnimation: UITableView.RowAnimation
    let insertAnimation: UITableView.RowAnimation
    let updateAnimation: UITableView.RowAnimation
    let expandAnimation: UITableView.RowAnimation
    let collapseAnimation: UITableView.RowAnimation

    /// Constructor where you set different type of animation for the section behaviour.
    /// - Parameters:
    ///   - deleteAnimation: UITableView.RowAnimation
    ///   - insertAnimation: UITableView.RowAnimation
    ///   - updateAnimation: UITableView.RowAnimation
    ///   - collapseAnimation: UITableView.RowAnimation
    ///   - expandAnimation: UITableView.RowAnimation
    public init(deleteAnimation: UITableView.RowAnimation = .automatic,
                insertAnimation: UITableView.RowAnimation = .automatic,
                updateAnimation: UITableView.RowAnimation = .automatic,
                collapseAnimation: UITableView.RowAnimation = .top,
                expandAnimation: UITableView.RowAnimation = .top) {
          self.deleteAnimation = deleteAnimation
          self.insertAnimation = insertAnimation
          self.updateAnimation = updateAnimation
          self.collapseAnimation = collapseAnimation
          self.expandAnimation = expandAnimation
      }
}

#endif
