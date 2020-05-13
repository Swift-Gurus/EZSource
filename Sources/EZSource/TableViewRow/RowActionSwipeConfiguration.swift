//
//  RowActionSwipeConfiguration.swift
//  
//
//  Created by Alex Hmelevski on 2020-05-11.
//

import Foundation

/**
   Struct to hold configuration for a row actions.
   Contains info about rows and fullSwipe flag
 */
public struct RowActionSwipeConfiguration {
    var actions: [RowAction]
    let performFirstActionWithFullSwipe: Bool

    /// Constructor
    /// - Parameters:
    ///   - actions: [`RowAction`]
    ///   - performFirstActionWithFullSwipe: Bool
    public init(actions: [RowAction] = [],
                performFirstActionWithFullSwipe: Bool = true) {
        self.actions = actions
        self.performFirstActionWithFullSwipe = performFirstActionWithFullSwipe
    }

    /// Convenience variable to get a configuration with emtpy `RowActions`
    /// and `performFirstActionWithFullSwipe` set to `true`
    public static var empty: RowActionSwipeConfiguration {
        RowActionSwipeConfiguration()
    }
}
