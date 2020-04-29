//
//  AnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

// MARK: - AnimationConfig
public struct AnimationConfig {
    let deleteAnimation: UITableView.RowAnimation
    let insertAnimation: UITableView.RowAnimation
    let updateAnimation: UITableView.RowAnimation
    let collapseAnimation: UITableView.RowAnimation
    let expandAnimation: UITableView.RowAnimation
    
    public init(deleteAnimation: UITableView.RowAnimation = .fade,
         insertAnimation: UITableView.RowAnimation = .left,
         updateAnimation: UITableView.RowAnimation = .right,
         collapseAnimation: UITableView.RowAnimation = .automatic,
         expandAnimation: UITableView.RowAnimation = .automatic) {
        self.deleteAnimation = deleteAnimation
        self.insertAnimation = insertAnimation
        self.updateAnimation = updateAnimation
        self.collapseAnimation = collapseAnimation
        self.expandAnimation = expandAnimation
    }
}
