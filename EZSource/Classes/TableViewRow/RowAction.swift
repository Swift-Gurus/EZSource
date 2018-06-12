//
//  RowAction.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

/// Higher-API class for UIContextualAction
public class RowAction {

    public var title: String? = nil
    public var backgroundColor: UIColor? = nil
    public var image: UIImage? = nil
    
    let action: () -> Void
    
    public init(action: @escaping ()->Void) {
        self.action = action
    }

}


// MARK: - Private API getters/setters
extension RowAction {
    var contextualAction: UIContextualAction {
        let contextual = UIContextualAction(style: .normal, title: title) { [weak self] (action, view, completion) in
            self?.action()
            completion(true)
        }
        
        contextual.backgroundColor = backgroundColor
        contextual.image = image
        return contextual
    }
}
