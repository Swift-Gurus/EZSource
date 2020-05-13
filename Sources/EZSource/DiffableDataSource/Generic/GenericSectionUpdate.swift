//
//  GenericSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-26.
//

import Foundation
import xDiffCollection

/// Generic class that represents suggested updates to the `DiffableDataSource`
open class GenericSectionUpdate<RowModel, SectionID> where
    RowModel: Hashable,
    SectionID: Hashable {

    /// Unique ID of the section
    public private(set) var id: SectionID

    /// Rows
    var rows: [RowModel] = []

    /// Returns numberof rows
    open var numberOfRows: Int { rows.count }

    /// Constructor
    /// - Parameter id: Unique ID of the section
    public init(id: SectionID) {
        self.id = id
    }
}
