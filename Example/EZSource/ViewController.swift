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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
     
        
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
//        tableView.allowsMultipleSelection = true
        
        source = TableViewDataSource(tableView: tableView,
                                     withTypes: [StringCell.self],
                                     reusableViews: [TestReusableView.self,TestReusableViewWithButton.self])
        source.dynamicSections = true

        var row = TableViewRow<StringCell>(model: "My Row",
                                           traillingSwipeConfiguration: RowActionSwipeConfiguration(),
                                           leadingSwipeConfiguration: RowActionSwipeConfiguration(),
                                           onTap: { (string) in debugPrint("tapped with \(string)")})
       
        let action = RowAction { [weak self] in
            let alertController = UIAlertController(title: "Action", message: "Done", preferredStyle: .alert)
            let act = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(act)
            self?.present(alertController, animated: true, completion: nil)
        }
        row.addRowLeadingActions([action])
        row.addRowTrailingActions([action])
        action.title = "Done"
        action.backgroundColor = .green
        var section = TableViewSection(id: "Test")
        let header = ImmutableHeaderFooterProvider<TestReusableView>.init(model: "My String header")

        var secondSection = TableViewSection(id: "Second Section")
        secondSection.addRows([row,row])
        let headerWithBottonModel = HeaderWithButtonModel(title: "My button Header \n jkljkjdflsjdlfkjs",
                                                          buttonText: "Collapse",
                                                          collapsedText: "test") { [weak row] in
            row?.model = "CHANGING"
            self.source.collapseSection(secondSection, collapse: !(self.source.isSectionCollapsed(secondSection) ?? false))
                                                            
        }
        
        let headerButton = MutableHeaderFooterProvider<TestReusableViewWithButton>(model: headerWithBottonModel)
        secondSection.addHeader(headerButton)
        
        headers[secondSection.id] = headerButton
        
        source.reload(with: [secondSection,section])
        
        let newHeader = HeaderWithButtonModel(title: "My button Header \n MODIFIED",
                                              buttonText: "Collapse",
                                              collapsedText: "test") {
                                                
                                                self.source.collapseSection(secondSection, collapse: !(self.source.isSectionCollapsed(secondSection) ?? false))
        }

        secondSection.addHeader(headerButton)
        section.addRows([row])
        
        section.addHeader(header)
        let updateInfo = UpdateInfo(section: section, changes: TableViewUpdates(insertedIndexes: [IndexPath(row: 0, section: 1)]))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.source.updateWithAnimation(updates: [updateInfo])
        }
        
        let newSection = TableViewSection(id: "Test")
        let updateInfo2 = UpdateInfo(section: newSection, changes: TableViewUpdates(deletedIndexes: [IndexPath(row: 0, section: 1)]))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.source.updateWithAnimation(updates: [updateInfo2])

        }

    }
}

