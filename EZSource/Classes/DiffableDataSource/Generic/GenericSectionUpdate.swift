//
//  GenericSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-26.
//

import Foundation
import xDiffCollection

open class GenericSectionUpdate<RowModel, SectionID> where
    RowModel: Hashable,
    SectionID: Hashable {
    
    public private(set) var id: SectionID
    var rows: [RowModel] = []
    open var numberOfRows: Int { rows.count }
    
    public init(id: SectionID) {
        self.id = id
    }
    
    
}
