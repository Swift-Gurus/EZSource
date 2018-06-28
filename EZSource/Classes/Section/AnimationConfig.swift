//
//  AnimationConfig.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

// MARK: - AnimationConfig
public struct AnimationConfig {
    let deleteAnimation: UITableViewRowAnimation
    let insertAnimation: UITableViewRowAnimation
    let updateAnimation: UITableViewRowAnimation
    let collapseAnimation: UITableViewRowAnimation
    let expandAnimation: UITableViewRowAnimation
    
    public init(deleteAnimation: UITableViewRowAnimation = .automatic,
         insertAnimation: UITableViewRowAnimation = .automatic,
         updateAnimation: UITableViewRowAnimation = .automatic,
         collapseAnimation: UITableViewRowAnimation = .automatic,
         expandAnimation: UITableViewRowAnimation = .automatic) {
        self.deleteAnimation = deleteAnimation
        self.insertAnimation = insertAnimation
        self.updateAnimation = updateAnimation
        self.collapseAnimation = collapseAnimation
        self.expandAnimation = expandAnimation
    }
}
