//
//  BinUpdateResult.swift
//  xDiffCollection
//
//  Created by Alex Hmelevski on 2018-06-18.
//

import Foundation

public struct BinUpdateResult<T, Backstorage: Collection> where Backstorage.Element == T {
    public let bin:  Backstorage
    public let changes: CollectionChanges<Backstorage.Index, [Backstorage.Index]>
    
    init(bin: Backstorage,
         changes: CollectionChanges<Backstorage.Index,[Backstorage.Index]> = CollectionChanges()) {
        self.bin = bin
        self.changes = changes
    }
}
