//
//  SectionAnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-28.
//

import Foundation
import UIKit

public struct SectionAnimationConfig {
    let deleteAnimation: UITableView.RowAnimation
    let insertAnimation: UITableView.RowAnimation
    let updateAnimation: UITableView.RowAnimation
    let expandAnimation: UITableView.RowAnimation
    let collapseAnimation: UITableView.RowAnimation
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

