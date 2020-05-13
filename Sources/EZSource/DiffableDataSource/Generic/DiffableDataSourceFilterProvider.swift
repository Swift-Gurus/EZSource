//
//  File.swift
//  
//
//  Created by Alex Hmelevski on 2020-05-11.
//

import Foundation
import xDiffCollection

/// Class - container that allows to append different type of filters
/// Used during initialization of  `DiffableDataSource`
public class DiffableDataSourceFilterProvider {

    typealias Filter = DiffCollectionFilter<AnyHashable>
    private(set) var filters: [Filter]  = []

    public init() { }

    /// Appends filter of type `DiffableDataSourceFilter<T,S>`
    /// - Parameter filter: DiffableDataSourceFilter<T, S>
    public func addFilter<T, S>(_ filter: DiffableDataSourceFilter<T, S>) where T: Hashable, S: Hashable {
        filters.append(filter.diffCollectionFilter)
    }
}
