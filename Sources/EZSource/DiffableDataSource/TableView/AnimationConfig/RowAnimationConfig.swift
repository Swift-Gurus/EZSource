//
//  RowAnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-28.
//

import Foundation
#if !os(macOS)
import UIKit

/**
   The struct that allows you to configure animation for the rows behaviour
    - Note:
    The amimations for row are set up per sections
*/
public struct RowAnimationConfig {
    let deleteAnimation: UITableView.RowAnimation
    let insertAnimation: UITableView.RowAnimation
    let updateAnimation: UITableView.RowAnimation

    /// Constructor where you set different type of animation for rows behaviour.
    /// - Parameters:
    ///   - deleteAnimation: UITableView.RowAnimation
    ///   - insertAnimation: UITableView.RowAnimation
    ///   - updateAnimation: UITableView.RowAnimation
    public init(deleteAnimation: UITableView.RowAnimation = .automatic,
                insertAnimation: UITableView.RowAnimation = .automatic,
                updateAnimation: UITableView.RowAnimation = .automatic) {
          self.deleteAnimation = deleteAnimation
          self.insertAnimation = insertAnimation
          self.updateAnimation = updateAnimation
    }
}

#endif
