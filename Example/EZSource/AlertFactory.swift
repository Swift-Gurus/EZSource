//
//  AlertFactory.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2020-04-23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


final class AlertFactory {
    func inputRowAlert(title: String,
                       config: AlertPlaceHoldersConfig,
                       actionHandler: @escaping (Int, Int, String) -> Void) -> UIAlertController {
        var rowNumber: UITextField?
        var sectionNumber: UITextField?
        var text: UITextField?
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        vc.addTextField { rowNumber = $0 }

        vc.addTextField { sectionNumber = $0 }
        
        vc.addTextField { text = $0 }

        rowNumber?.placeholder = config.top
        sectionNumber?.placeholder = config.middle
        text?.placeholder = config.bottom
        
        let action = UIAlertAction(title: "OK", style: .default) {(_) in
            defer {
               vc.dismiss(animated: true, completion: nil)
            }
            guard let row = rowNumber?.text.flatMap({ Int($0)}),
               let section = sectionNumber?.text.flatMap({ Int($0)}) else {
                   return
            }
            actionHandler(row,section,text?.text ?? "")
        }
        vc.addAction(action)
               
        return vc
    }
    
    func deleteRowAlert(title: String,
                       actionHandler: @escaping (Int, Int) -> Void) -> UIAlertController {
        var rowNumber: UITextField?
        var sectionNumber: UITextField?
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        vc.addTextField { rowNumber = $0 }

        vc.addTextField { sectionNumber = $0 }

        rowNumber?.placeholder = "Input Row Number"
        sectionNumber?.placeholder = "Input Section Number"
        
        let action = UIAlertAction(title: "OK", style: .default) {(_) in
            defer {
               vc.dismiss(animated: true, completion: nil)
            }
            guard let row = rowNumber?.text.flatMap({ Int($0)}),
               let section = sectionNumber?.text.flatMap({ Int($0)}) else {
                   return
            }
            actionHandler(row,section)
        }
        vc.addAction(action)
               
        return vc
    }
    
    
    func deleteRowAlertAction(title: String,
                              actionHandler: @escaping (Int, Int) -> Void) -> UIAlertAction {
           let vc = UIApplication.shared.keyWindow?.rootViewController
           let input = deleteRowAlert(title: title, actionHandler: actionHandler)
                  return UIAlertAction(title: title,
                                       style: .default) {  (_) in
                vc?.present(input, animated: true, completion: nil)
           }
    }
    
    
    func inputRowAlertAction(title: String,
                             config: AlertPlaceHoldersConfig = .inputOneRow,
                             actionHandler: @escaping (Int, Int, String) -> Void) -> UIAlertAction {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        let input = inputRowAlert(title: title,
                                  config: config,
                                  actionHandler: actionHandler)
               return UIAlertAction(title: title,
                                    style: .default) {  (_) in
                                        vc?.present(input, animated: true, completion: nil)
        }
    }
    
    
    struct AlertPlaceHoldersConfig {
        let top: String
        let middle: String
        let bottom: String
        
        static var inputOneRow: Self {
            .init(top: "Input Row Number",
                  middle: "Input Section Number",
                  bottom: "Row Value")
        }
        
        static var multipleRows: Self {
            .init(top: "Input number of rows",
                  middle: "Input Section Number",
                  bottom: "Rows Value")
        }
    }
    
    
}
