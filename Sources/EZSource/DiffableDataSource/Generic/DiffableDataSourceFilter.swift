//
//  DiffableDataSourceFilter.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-26.
//

import Foundation
import xDiffCollection

/**
    Class adapter to provide section filter. Based on the filter function `DiffableDataSource` decides
    what goes into a particular section.
 
    -   Generic type `T` stands for type of a model.
    -   Generic type `S` stands for the unique ID of a Section
    
    **Usage Example**
    
    - Assuming we have the next model:
 
    ````
    enum TextModelMockType: String {
        case type1
        case type2
        case type3
    }

    /// Type represent unique item
    /// Text is something that is dynamic and can be changed
    struct TextModelMock: Hashable {
        let text: String
        let type: TextModelMockType
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(type)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.text == rhs.text
        }
    }

    ````
 
 */
public final class DiffableDataSourceFilter<T, S> where T: Hashable, S: Hashable {

    typealias Model = DiffableDataSource.InputModel
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

            guard let filter = filterFunction else { return filterID == id }
            return  filter(model)
        })
    }

    struct FilterModel {
        let model: T

    }
}
