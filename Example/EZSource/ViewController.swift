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
    var headers: [String: MutableHeaderFooterProvider<HeaderWithButtonModel, TestReusableViewWithButton>] = [:]
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
        
        var row = TableViewRow<String, StringCell>(model: "My Row")
       
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
        let header = ImmutableHeaderFooterProvider<String,TestReusableView>.init(model: "My String header")
        section.addRows([row])
        section.addHeader(header)
        
        var secondSection = TableViewSection(id: "Second Section")
        secondSection.addRows([row,row,row])
        let headerWithBottonModel = HeaderWithButtonModel(title: "My button Header \n jkljkjdflsjdlfkjs",
                                                          buttonText: "Collapse",
                                                          collapsedText: "test") {
            
            self.source.collapseSection(secondSection, collapse: !self.source.isSectionCollapsed(secondSection))
                                                            
        }
        
        let headerButton = MutableHeaderFooterProvider<HeaderWithButtonModel, TestReusableViewWithButton>(model: headerWithBottonModel)
        secondSection.addHeader(headerButton)
        
        headers[secondSection.id] = headerButton
        
        source.reload(with: [secondSection,section])
        
        let newHeader = HeaderWithButtonModel(title: "My button Header \n MODIFIED",
                                              buttonText: "Collapse",
                                              collapsedText: "test") {
                                                
                                                self.source.collapseSection(secondSection, collapse: !self.source.isSectionCollapsed(secondSection))
                                                
        }

        secondSection.addHeader(headerButton)
        secondSection.addRows([row])
        let updateInfo = UpdateInfo(section: secondSection, changes: TableViewUpdates(insertedIndexes: [IndexPath(row: 3, section: 0)]))
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.source.updateWithAnimation(updates: [updateInfo])
            self.headers[secondSection.id]?.update(withModel: newHeader)
        }
        
    }
}

