//
//  DefatultHeaderFooterProvider.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-22.
//

import Foundation
#if !os(macOS)
import UIKit

struct DefatultHeaderFooterProvider: SectionHeaderFooterProvider {
    var title: String?

    var height: CGFloat?

    func headerView(forTableView: UITableView) -> UIView? {
        return nil
    }

}
#endif
