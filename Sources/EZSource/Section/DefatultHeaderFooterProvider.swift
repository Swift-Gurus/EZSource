//
//  DefatultHeaderFooterProvider.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2020-04-22.
//

import Foundation
import UIKit

struct DefatultHeaderFooterProvider: SectionHeaderFooterProvider {
    var title: String? = nil
    
    var height: CGFloat? = nil
    
    func headerView(forTableView: UITableView) -> UIView? {
        return nil
    }
    
}
