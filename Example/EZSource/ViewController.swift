//
//  ViewController.swift
//  EZSource
//
//  Created by AlexHmelevskiAG on 06/04/2018.
//  Copyright (c) 2018 AlexHmelevskiAG. All rights reserved.
//

import UIKit
import EZSource

class ViewController: UIViewController {

    var tableView: UITableView!
    var source: DiffableTableViewDataSource!
    var headers: [String: MutableHeaderFooterProvider<TestReusableViewWithButton>] = [:]
    var alertFactory = AlertFactory()
    let section1ID = "section1ID"
    let section2ID = "section2ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let config = DiffableTableViewDataSource.Config(tableView: tableView,
                                                        cellTypes: [StringCell.self],
                                                        headerFooters: [TestReusableView.self,
                                                                        TestReusableViewWithButton.self])
        source = DiffableTableViewDataSource(config: config)
        tableView.allowsMultipleSelection = true

        source.update(sections: [sectionWithTextLabelsUpdates, secondSectionUpdates])
    
        createNavigationItem()
    }

    private func immutableHeader(for id: String) -> ImmutableHeaderFooterProvider<TestReusableView> {
        ImmutableHeaderFooterProvider<TestReusableView>(model: "Immutable Header. Section: \(id)")
    }
    
    private var sectionWithTextLabelsUpdates: TableViewDiffableSection {
        let updates = TableViewDiffableSection(id: "\(section1ID)")
        updates.addHeader(immutableHeader(for: section1ID))
        let ids = stride(from: 0, to: 3, by: 1).map({ "Row\($0)"})
        let rows = getRows(with: ids)
        updates.addRows(rows)
        return updates
    }
    
    private var secondSectionUpdates: TableViewDiffableSection {
        let updates = TableViewDiffableSection(id: section2ID)
        let header = headerWithCollapseButton(for: section2ID)
        updates.addHeader(header)
        updates.settings.collapsed = true
        let ids = stride(from: 3, to: 10, by: 1).map({ "Row\($0)"})
        let rows = getRows(with: ids)
        updates.addRows(rows)
        return updates
    }

    
    private func createRow(with ID: String, title: String) -> TableViewRow<StringCell>  {
        let model = StringCellModel(uniqueID: ID, text: title)
        let row = TableViewRow<StringCell>(model: model,
                                           onTap: { debugPrint("tapped with \($0)")})
        row.addRowLeadingActions(leadingActions)
        row.addRowTrailingActions(trailingActions)
        return row
    }
    
    private func getRows(with ids: [String]) -> [TableViewRow<StringCell>] {
        ids.map({ createRow(with: $0, title: "Default")})
    }
    
    private var rowAction: RowAction {
        RowAction { [weak self] in
            guard let `self` = self else { return }
            let alertController = self.alertControllerExample
            let act = self.dismissAction(for: alertController)
            alertController.addAction(act)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private var leadingActions: [RowAction] {
        let action = rowAction
        action.backgroundColor = .green
        action.title = "Done"
        return [action]
    }
    
    private var trailingActions: [RowAction] {
        let action = rowAction
        action.backgroundColor = .red
        action.title = "Alert"
        return [action]
    }
    
    
    private func headerWithCollapseButton(for setionID: String) -> MutableHeaderFooterProvider<TestReusableViewWithButton> {
        let model = HeaderWithButtonModel(title: "Section with button: Section ID: \(setionID)",
                                          buttonText: "Collapse",
                                          collapsedText: "Expand") { [weak self] in
                                            self?.source.autoCollapseExpandSection(with: setionID)
        }
        return MutableHeaderFooterProvider(model: model)
    }
    
    
    private var alertControllerExample: UIAlertController {
        UIAlertController(title: "Action", message: "Done", preferredStyle: .alert)
    }
    
    func dismissAction(for alert: UIAlertController) -> UIAlertAction {
       UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
       })
    }
}

extension ViewController {
    func createNavigationItem() {
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActionList))
        item.tintColor = .black
        navigationItem.title = "EXAMPLE"
        navigationItem.setRightBarButton(item, animated: true)
    }
    
    @objc func showActionList() {
        let actionSheet =  UIAlertController(title: "Action", message: "Done", preferredStyle: .actionSheet)
        actionSheet.addAction(addRowAction)
        actionSheet.addAction(updateRowAction)
        actionSheet.addAction(dismissAction(for: actionSheet))
        self.present(actionSheet, animated: true, completion: nil)
    }
    

    
    private var updateRowAction: UIAlertAction{
        alertFactory.inputRowAlertAction(title: "Update Row",
                                         actionHandler: { [weak self] row,section, text  in
                                            self?.addUpdateRow(with: row, section: section, text: text)
                                                   
        })
    }
    
    private var addRowAction: UIAlertAction {
        alertFactory.inputRowAlertAction(title: "Add Row",
                                         actionHandler: { [weak self] row,section, text  in
              self?.addUpdateRow(with: row, section: section, text: text)
        })
    }
    
    private var deleteRow: UIAlertAction {
        alertFactory.deleteRowAlertAction(title: "Delete Row",
                                          actionHandler: { [weak self] row,section in
               self?.deleteRow(at: row, section: section)
        })
    }
    
    private func addUpdateRow(with ID: String, section: String, text: String) {
        let sectionChanges = TableViewDiffableSection(id: "\(section)")
        let row = createRow(with: ID, title: text)
        sectionChanges.addRows([row])
        source.update(sections: [sectionChanges])
    }
    

    
    private func deleteRow(at index: Int, section: Int) {
//        var updates = TableViewSectionUpdate(sectionID: "\(section)")
//        updates.addDeleteOperation(at: IndexPath(row: index, section: section))
//        source.applyChanges([updates])
    }
    
    
    
}
