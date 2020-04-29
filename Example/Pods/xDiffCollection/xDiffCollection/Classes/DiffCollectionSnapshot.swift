//
//  DiffCollectionSnapshot.swift
//  xDiffCollection
//
//  Created by Alex Hmelevski on 2020-04-23.
//

import Foundation

public struct DiffCollectionSnapshot<E: Hashable> {
    public let element: E
    public let collection: DiffCollection<E>
    public let changes: DiffCollectionResult
}

