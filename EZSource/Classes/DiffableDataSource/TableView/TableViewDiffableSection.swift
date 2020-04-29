//
//  TableViewDiffableSection.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-27.
//

import Foundation

public final class TableViewDiffableSection: GenericSectionUpdate<AnyHashable, String> {
    
    public var settings: Settings = .init()
    
    public func addRows<Cell>(_ rows: [TableViewRow<Cell>]) where Cell: Configurable & ReusableCell, Cell.Model: Hashable & Equatable {
        self.rows.append(contentsOf: rows.map(AnyHashable.init))
    }
    
    public func addHeader<View>(_ header: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        settings.headerProviderUpdate = .new(header)
    }
       
    public func addFooter<View>(_ footer: HeaderFooterProvider<View>) where View: Configurable & ReusableView {
        settings.footerProviderUpdate = .new(footer)
    }
}

extension TableViewDiffableSection {
    public enum HeaderFooterUpdate {
          case new(SectionHeaderFooterProvider)
          case reuse
          case empty
          case `default`
    }
    
    public struct Settings {
        public var rowAnimationConfig = RowAnimationConfig()
        public var sectionAnimationConfg = SectionAnimationConfig()
        public var headerProviderUpdate: HeaderFooterUpdate = .reuse
        public var footerProviderUpdate: HeaderFooterUpdate = .reuse
        public var collapsed: Bool = false
        var dynamic: Bool  = false
    }
}
