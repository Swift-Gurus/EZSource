//
//  RowAction.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation
#if !os(macOS)
import UIKit

/** Higher-API class for UIContextualAction
        
    **Example Usage**
    - Create Action
 
    ````
    var rowAction: RowAction {
        RowAction { [weak self] in
            guard let `self` = self else { return }
            let alertController = self.alertControllerExample
            let act = self.dismissAction(for: alertController)
            alertController.addAction(act)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    ````
    - set up title and color
 
    ````
    var leadingActions: [RowAction] {
        let action = rowAction
        action.backgroundColor = .green
        action.title = "Done"
        return [action]
    }
    ````
    - add to a row
 
    ````
    let model = StringCellModel(uniqueID: ID, text: title)
    let row = TableViewRow<StringCell>(model: model,
                                       onTap: { debugPrint("tapped with \($0)")})
    row.addRowLeadingActions(leadingActions)

    ````
*/
public class RowAction {

    /// Title of the action
    public var title: String?

    /// Background color
    public var backgroundColor: UIColor?

    /// Image
    public var image: UIImage?

    let action: () -> Void

    /// Constructor
    /// - Parameter action: Action that is performed on action tap
    public init(action: @escaping () -> Void) {
        self.action = action
    }
}

// MARK: - Private API getters/setters
extension RowAction {
    var contextualAction: UIContextualAction {
        let contextual = UIContextualAction(style: .normal, title: title) { [weak self] (action, _, completion) in
            self?.action()
            completion(true)
        }

        contextual.backgroundColor = backgroundColor
        contextual.image = image
        return contextual
    }
}

extension UISwipeActionsConfiguration {
    convenience init(config: CellActionSwipeConfiguration) {
        self.init(actions: config.contextualActions)
        performsFirstActionWithFullSwipe = config.performFirstActionWithFullSwipe
    }
}

#endif
