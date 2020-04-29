//
//  RowAnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-28.
//

import Foundation

public struct RowAnimationConfig {
    let deleteAnimation: UITableView.RowAnimation
    let insertAnimation: UITableView.RowAnimation
    let updateAnimation: UITableView.RowAnimation
    public init(deleteAnimation: UITableView.RowAnimation = .automatic,
                insertAnimation: UITableView.RowAnimation = .automatic,
                updateAnimation: UITableView.RowAnimation = .automatic) {
          self.deleteAnimation = deleteAnimation
          self.insertAnimation = insertAnimation
          self.updateAnimation = updateAnimation
    }
}
