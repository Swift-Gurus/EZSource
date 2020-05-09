//
//  DiffableDataSource.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-26.
//

import Foundation
import xDiffCollection

public class DiffableDataSource: NSObject {
    
    public typealias Index = IndexPath
    typealias Filter = DiffCollectionFilter<AnyHashable>
    var xDiffCollection: DiffCollection<AnyHashable>
    
    public var numberOfSections: Int {
        xDiffCollection.count
    }
    
    public func numberOfElements(at index: Int) -> Int {
        xDiffCollection.numberOfElements(at: index)
    }

    init(provider: DiffableDataSourceFilterProvider) {
        xDiffCollection = DiffCollection<AnyHashable>(filters: provider.filters)
        super.init()
    }
     
    func element<T>(at path: IndexPath) -> T? {
        xDiffCollection.element(at: path.section)
                       .map({ $0.element(at: path.row) })
                       .flatMap({ $0?.base })
                       .flatMap({ $0 as? InputModel })
                       .flatMap({ $0.model.base  as? T })
    }
    
    @discardableResult
    func update<T, S>(using models: [GenericSectionUpdate<T, S>]) -> SourceUpdate<T,S> {
        let indexes = createSourceIfNeed(ids: models)
        
        let updates: [SectionUpdate<T, S>] = models.flatMap(convert)
                                                   .compactMap(self.update)
                                                   .compactMap({ $0 })
        
        return SourceUpdate(insertedIndexes: indexes, sectionUpdates: updates)
    }
    
    private func createSourceIfNeed<T, S>(ids: [GenericSectionUpdate<T, S>]) -> [Int] {
        guard numberOfSections == 0 else { return [] }
        let filters = createDefaultFilters(for: ids)
        xDiffCollection = .init(filters: filters.map({ $0.diffCollectionFilter} ))
        return stride(from: 0, to: ids.count, by: 1).map({ $0 })
    }
     
    private func createDefaultFilters<T,S>(for ids: [GenericSectionUpdate<T, S>]) -> [DiffableDataSourceFilter<T, S>] {
        ids.map({ $0.id }).map({ DiffableDataSourceFilter(id: $0) })
    }
    
    private func convert<T, S>(section: GenericSectionUpdate<T, S>) -> [InputModel] where T: Hashable, S: Hashable {
        section.rows.map({ InputModel(sectionID: section.id, model: $0) })
    }
    
    func update<T, S>(with item: InputModel) -> SectionUpdate<T, S>? {
        let erasedModel = AnyHashable(item)
        let snapshot = xDiffCollection.update(with: erasedModel)
        return convertToOperations(changes: snapshot.changes, item: item)
    }

    private func convertToOperations<T, S>(changes: DiffCollectionResult,
                                           item: InputModel) -> SectionUpdate<T, S>? {
        guard let model = item.model.base as? T,
                let sectionID = item.sectionID.base as? S else {
                return nil
        }
        
        return SectionUpdate(insertedIndexes: changes.addedIndexes,
                             removedIndexes: changes.removedIndexes,
                             updatedIndexes: changes.updatedIndexes,
                             model: model,
                             id: sectionID)
    }
    
}

extension DiffableDataSource {
    public struct InputModel: Hashable {
        let sectionID: AnyHashable
        let model: AnyHashable
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(model)
        }
    
    }
}

extension DiffableDataSource {

    struct SectionUpdate<T, S>: Equatable where T: Hashable, S: Hashable {
        let insertedIndexes: [IndexPath]
        let removedIndexes: [IndexPath]
        let updatedIndexes: [IndexPath]
        let model: T
        let id: S
    }
    
    struct SourceUpdate<T, S>: Equatable  where T: Hashable, S: Hashable {
        let insertedIndexes: [Int]
        let sectionUpdates: [SectionUpdate<T,S>]
    }

    enum Operation {
        case update(IndexPath)
        case remove(IndexPath)
        case add(IndexPath)
    }
}
