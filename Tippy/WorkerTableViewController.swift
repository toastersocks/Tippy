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
    
    var emptyView: EmptyView = EmptyView()
    var showEmptyViewWhenLessThan = 1
    var formatter: Formatter?
    
    @IBOutlet weak var addNewButton: UIButton!
    
    override func viewDidLoad() {
        // These two lines are nessesary so table view cells don't overlap 
        // over each other on iOS 8.1 & 8.2
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView = emptyView
        hideEmptyView()
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
        viewModel.addWorkerWithName("", method: .Amount, value: "0", atIndex: viewModelCount)
        
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
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { fatalError("Expected a TableViewCell; got a \(cell.dynamicType) instead") }
        
        tableViewCell.viewModel = viewModel[indexPath.row]
        tableViewCell.accessibilityLabel = "Worker \(indexPath.item) with name \(tableViewCell.workerView.nameField.text)"
        tableViewCell.accessibilityIdentifier = "worker\(indexPath.item)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = viewModel?.count ?? 0
        if rows < showEmptyViewWhenLessThan  && emptyView.hidden == true {
            showEmptyView()
        } else if rows >= showEmptyViewWhenLessThan && emptyView.hidden == false {
            hideEmptyView()
        }
        return rows
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
    
    // MARK: Empty View
    
    func showEmptyView() {
        emptyView.hidden = false
        tableView.bringSubviewToFront(emptyView)
    }
    
    func hideEmptyView() {
        emptyView.hidden = true
        tableView.sendSubviewToBack(emptyView)
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
        guard let
            indexPath = tableView.indexPathForCell(cell),
            activeText = tipoutView.activeTextField?.text ?? .Some("0"),
            tag = tipoutView.activeTextField?.tag ?? .Some(3), // Amount tag
            textFieldTag = TipoutView.TipoutViewField(rawValue: tag)
        else { return }
        
        viewModel.addWorkerWithName(
            tipoutView.nameField.text ?? "",
            method: textFieldTag,
            value: activeText,
            atIndex: indexPath.row)
        
        cell.viewModel = viewModel[indexPath.row]
    }
    
    func tipoutViewDidBeginEditing(tipoutView: TipoutView, textField: UITextField) {
        guard let
            cell = tableViewCellForTipoutView(tipoutView),
            indexPath = tableView.indexPathForCell(cell)
            else { fatalError("Couldn't get tableViewCell or index") }
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    
    func tipoutViewDidEndEditing(tipoutView: TipoutView) {
        guard let activeField = tipoutView.activeTextField,
            text = activeField.text,
        formatter = formatter else { return }
        switch TipoutView.TipoutViewField(rawValue: activeField.tag) {
        case .Amount?: activeField.text = try? formatter.formatNumberString(text)
        case .Percentage?: activeField.text = try? formatter.formatPercentageString(text)
        case .Hours?: activeField.text = try? formatter.formatNumberString(text)
        case .Name?: break
        case nil: break
            }
    }
    
    func tipoutView(tipoutView: TipoutView, textField: UITextField, textDidChange text: String) {
        handleInputForTipoutView(tipoutView, activeText: text)
    }
    
    func tipoutView(tipoutView: TipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text ?? ""
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
        if !newString.isEmpty {
            do {
                switch TipoutView.TipoutViewField(rawValue: textField.tag) {
                case .Amount?: try formatter?.currencyFromString(newString)
                case .Percentage?: try formatter?.percentageFromString(newString)
                case .Hours?: try formatter?.formatNumberString(newString)
                case .Name?: break
                case nil: break
                }
            } catch {
                return false
            }
        }
        return true
    }
}