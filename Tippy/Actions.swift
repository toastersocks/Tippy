//
//  Actions.swift
//  Tippy
//
//  Created by James Pamplona on 9/24/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

extension TipoutsTVC {
    
    @IBAction func combine() {
        guard let viewController = storyboard?.instantiateViewControllerWithIdentifier("tipoutvc") as? ViewController else { fatalError("Unable to instantiate ViewController") }
        
        navigationController?.pushViewController(viewController, animated: true)
        
        let combinedTipoutViewModel = controller.combinedTipoutsViewModel()
        let newController = Controller(tipoutViewModel: combinedTipoutViewModel, numberFormatter: formatter)
        
        viewController.controller = newController
    }
    
    @IBAction func clearAll() {
        controller.removeAll()
        tableView.beginUpdates()
        tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .Left)
        tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: .Right)
        tableView.endUpdates()
    }
}

private extension Selector {
    static let combine = #selector(TipoutsTVC.combine)
    static let new = #selector(TipoutsTVC.new)
    //    static let done = #selector(TipoutsTVC.done)
    //    static let clear = #selector(TipoutsTVC.clear(_:))
    static let clearAll = #selector(TipoutsTVC.clearAll)
}