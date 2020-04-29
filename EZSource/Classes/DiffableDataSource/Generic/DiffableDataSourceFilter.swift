//
//  DiffableDataSourceFilter.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-26.
//

import Foundation
import xDiffCollection

public class DiffableDataSourceFilterProvider {
    typealias Filter = DiffCollectionFilter<AnyHashable>
    private(set) var filters: [Filter]  = []
    
    public init() { }
    
    public func addFilter<T, S>(_ filter: DiffableDataSourceFilter<T, S>) where T: Hashable, S: Hashable {
        filters.append(filter.diffCollectionFilter)
    }
}


public final class DiffableDataSourceFilter<T, S> where T: Hashable, S: Hashable {

    public typealias Model = DiffableDataSource.InputModel
    typealias Filter = DiffCollectionFilter<AnyHashable>
    let id: S
    let filter: ((T) -> Bool)?
    
    public init(id: S, filter: ((T) -> Bool)? = nil) {
        self.filter = filter
        self.id = id
    }

    var diffCollectionFilter: Filter {
        let filterID = id
        let filterFunction = self.filter
        return Filter(name: "Filter", filter: { (model) -> Bool in
            guard let typeCastedModel = model.base as? Model,
                let id = typeCastedModel.sectionID.base as? S,
                let model = typeCastedModel.model.base as? T else { return false }
            
            guard let filter = filterFunction else { return filterID == id  }
            return  filter(model)
        })
    }
    
    public struct FilterModel {
        let model: T

    }
}
