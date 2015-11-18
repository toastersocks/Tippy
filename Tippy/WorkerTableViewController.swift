//
//  WorkerTableViewController.swift
//  Tippy
//
//  Created by James Pamplona on 7/31/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit

class WorkerTableViewController: UITableViewController, TipoutViewDelegate {
    static let workerCellID = "workerCell"
    
    var viewModel: TipoutViewModelType! {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var addNewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resetPropertiesOfTipoutView(view: TipoutView) {
        view.delegate = nil
        view.activeTextField = nil
    }
    
    @IBAction func newWorker() {
        let viewModelCount = viewModel.count
        viewModel.addWorkerWithName("", method: "amount", value: "0.0", atIndex: viewModelCount)
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: viewModelCount, inSection: 0)], withRowAnimation: .Automatic)
        tableView.endUpdates()
        
        guard let workerView = (tableView.cellForRowAtIndexPath(
            NSIndexPath(forRow: viewModelCount, inSection: 0))
            as? TableViewCell)?.workerView else { return }
        
        workerView.nameField.becomeFirstResponder()
    }
    
    // MARK: TableViewDelegate/DataSource

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(WorkerTableViewController.workerCellID) as? TableViewCell
            else { fatalError("Expected a TableViewCell") }
        resetPropertiesOfTipoutView(cell.workerView)
        cell.workerView.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { fatalError("Expected a TableViewCell; got a \(cell.dynamicType) instead") }
        
        tableViewCell.viewModel = viewModel[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            viewModel.removeWorkerAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
    
    // MARK: TipoutView
    
    func tableViewCellForTipoutView(tipoutView: TipoutView) -> TableViewCell? {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? TableViewCell else { fatalError("Wrong cell type. Expected a TableViewCell") }
        
        return cell
    }
    
    func handleInputForTipoutView(tipoutView: TipoutView, activeText: String?) {
        guard let cell = tableViewCellForTipoutView(tipoutView) else { fatalError("Couldn't get tableViewCell") }
        if let indexPath = tableView.indexPathForCell(cell) {
            
            if let activeText = activeText, placeholderText = tipoutView.activeTextField?.placeholder {
                
                viewModel.addWorkerWithName(
                    tipoutView.nameField.text ?? "",
                    method: placeholderText,
                    value: activeText,
                    atIndex: indexPath.row)
                
                cell.viewModel = viewModel[indexPath.row]
            }
        }
    }
    
    func tipoutViewDidBeginEditing(tipoutView: TipoutView, textField: UITextField) {
        guard let
            cell = tableViewCellForTipoutView(tipoutView),
            indexPath = tableView.indexPathForCell(cell)
            else { fatalError("Couldn't get tableViewCell or index") }
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    
    func tipoutViewDidEndEditing(tipoutView: TipoutView) {
        handleInputForTipoutView(tipoutView, activeText: tipoutView.activeTextField?.text)
    }
    
    func tipoutView(tipoutView: TipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString? = textField.text
        let proposedText = currentText?.stringByReplacingCharactersInRange(range, withString: string)
        handleInputForTipoutView(tipoutView, activeText: proposedText)
        return true
    }
}