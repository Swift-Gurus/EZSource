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
    var source: TableViewDataSource!
    var headers: [String: MutableHeaderFooterProvider<TestReusableViewWithButton>] = [:]
    var alertFactory = AlertFactory()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        source = TableViewDataSource(tableView: tableView,
                                     withTypes: [StringCell.self],
                                     reusableViews: [TestReusableView.self,TestReusableViewWithButton.self])
        tableView.allowsMultipleSelection = true

        source.applyChanges([sectionWithTextLabelsUpdates, secondSectionUpdates])
        createNavigationItem()
    }

    private func headerWithCollapseButton(for setionID: String) -> MutableHeaderFooterProvider<TestReusableViewWithButton> {
        let model = HeaderWithButtonModel(title: "Section with button",
                                          buttonText: "Collapse",
                                          collapsedText: "Expand") { [weak self] in
            guard let `self` = self,
            let collapsedFlag = self.source.isSectionCollapsed(setionID) else { return }
            self.source.collapseSection(setionID, collapse: !collapsedFlag)
        }
        return MutableHeaderFooterProvider(model: model)
    }
    
    private var sectionWithTextLabelsHeader: ImmutableHeaderFooterProvider<TestReusableView> {
        ImmutableHeaderFooterProvider<TestReusableView>(model: "Section with text labels")
    }
    
    private var sectionWithTextLabelsUpdates: TableViewSectionUpdate {
        var updates = TableViewSectionUpdate(sectionID: "\(0)")
        updates.addHeader(sectionWithTextLabelsHeader)
        let rows = getRows(count: 2)
        rows.enumerated()
            .map({ ($0.element, IndexPath(row: $0.offset, section: 0)) })
            .forEach({ updates.addAddOperation($0.0, at: $0.1) })
       return updates
    }
    
    private var secondSectionUpdates: TableViewSectionUpdate {
        let id = "\(1)"
        var updates = TableViewSectionUpdate(sectionID: id)
        let header = headerWithCollapseButton(for: id)
        updates.addHeader(header)
        let rows = getRows(count: 2)
       
        rows.enumerated()
            .map({ ($0.element, IndexPath(row: $0.offset, section: 1)) })
            .forEach({ updates.addAddOperation($0.0, at: $0.1) })
        return updates
    }
    
    private var textLabelRow: TableViewRow<StringCell> {
        createRow(title: "My row")
    }
    
    private func createRow(title: String) -> TableViewRow<StringCell>  {
        let row = TableViewRow<StringCell>(model: title,
                                           onTap: { debugPrint("tapped with \($0)")})
        row.addRowLeadingActions(leadingActions)
        row.addRowTrailingActions(trailingActions)
        return row
    }
    
    private func getRows(count: Int) -> [TableViewRow<StringCell>] {
        stride(from: 0, to: count, by: 1).map({ _ in textLabelRow})
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
        actionSheet.addAction(deleteRow)
        actionSheet.addAction(updateRowAction)
        actionSheet.addAction(addRowsAction)
        actionSheet.addAction(dismissAction(for: actionSheet))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    private var addRowsAction: UIAlertAction {
       alertFactory.inputRowAlertAction(title: "Add Multiple Rows",
                                        config: .multipleRows,
                                        actionHandler: { [weak self] numberOfRows,section, text  in
                               self?.addRows(numberOfRows: numberOfRows, section: section, text: text)
                                                   
        })
    }
    
    private var updateRowAction: UIAlertAction{
        alertFactory.inputRowAlertAction(title: "Update Row",
                                         actionHandler: { [weak self] row,section, text  in
                               self?.updateRow(at: row, section: section, text: text)
                                                   
        })
    }
    
    private var addRowAction: UIAlertAction {
        alertFactory.inputRowAlertAction(title: "Add Row",
                                         actionHandler: { [weak self] row,section, text  in
               self?.addRow(at: row, section: section, text: text)
        })
    }
    
    private var deleteRow: UIAlertAction {
        alertFactory.deleteRowAlertAction(title: "Delete Row",
                                          actionHandler: { [weak self] row,section in
               self?.deleteRow(at: row, section: section)
        })

    }
    
    private func addRows(numberOfRows: Int, section: Int, text: String) {
        var updates = TableViewSectionUpdate(sectionID: "\(section)")
        stride(from: 0, to: numberOfRows, by: 1).map({ IndexPath(row: $0, section: section) })
            .forEach({ updates.addAddOperation(createRow(title: text), at: $0)})
        source.applyChanges([ updates ])
    }
    
    private func addRow(at index: Int, section: Int, text: String) {
        var updates = TableViewSectionUpdate(sectionID: "\(section)")
        let row = createRow(title: text)
        updates.addAddOperation(row, at: IndexPath(row: index, section: section))
        source.applyChanges([updates])
    }
    
    private func updateRow(at index: Int, section: Int, text: String) {
        var updates = TableViewSectionUpdate(sectionID: "\(section)")
        let row = createRow(title: text)
        updates.addUpdateOperation(row, at: IndexPath(row: index, section: section))
        source.applyChanges([updates])
    }
    
    private func deleteRow(at index: Int, section: Int) {
        var updates = TableViewSectionUpdate(sectionID: "\(section)")
        updates.addDeleteOperation(at: IndexPath(row: index, section: section))
        source.applyChanges([updates])
    }
}
