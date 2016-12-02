//
//  EditableWorkerTableViewController.swift
//  Tippy
//
//  Created by James Pamplona on 7/31/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import PopupDialog


class EditableWorkerTableViewController: WorkerTableViewController, TipoutViewDelegate {

    static let workerCellID = "workerCell"
    
    /*var viewModel: TipoutViewModelType! {
        didSet {
            tableView.reloadData()
        }
    }*/
    
    /*var emptyView: EmptyView = EmptyView()
    var showEmptyViewWhenLessThan = 1
    var formatter: Formatter?*/
    
    /*@IBOutlet weak var addNewButton: UIButton!*/
    
    /*override func viewDidLoad() {
        // These two lines are nessesary so table view cells don't overlap 
        // over each other on iOS 8.1 & 8.2
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView = emptyView
        hideEmptyView()
        super.viewDidLoad()
    }*/

    func resetPropertiesOfTipoutView(view: EditableTipoutView) {
        view.delegate = nil
        view.activeTextField = nil
    }
    
    @IBAction func editWorker(atIndex index: Int) {
        let editWorkerVC = EditWorkerViewController(nibName: "EditWorkerViewController", bundle: nil)
        guard let bundle = NSBundle(identifier: "com.apple.UIKit") else { fatalError("Coudn't access bundle") }
        
        let cancelButton = CancelButton(title: bundle.localizedStringForKey("Cancel", value: "", table: nil), action: nil)
        cancelButton.accessibilityIdentifier = "cancelButton"
        cancelButton.accessibilityLabel = bundle.localizedStringForKey("Cancel", value: "", table: nil)
        let doneButton = DefaultButton(title: bundle.localizedStringForKey("Done", value: "", table: nil)) {
            let method: TipoutViewField = {
                switch editWorkerVC.currentMethodIndex {
                case 0: // Hourly
                    return TipoutViewField.Hours
                case 1: // Percent
                    return TipoutViewField.Percentage
                case 2: // Amount
                    return TipoutViewField.Amount
                default:
                    fatalError("Unknown value for tipout method")
                }
            }()
            
            let value = editWorkerVC.currentValue ?? "0"
            
            let viewModelCount = self.viewModel.count
            let name = editWorkerVC.nameField.text ?? ""
            
            self.viewModel.addWorkerWithName(name, method: method, value: value, atIndex: viewModelCount)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: viewModelCount, inSection: 0)], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
        }
        
        let editWorkerPopup = PopupDialog(viewController: editWorkerVC,
                                          buttonAlignment: .Horizontal,
                                          transitionStyle: .ZoomIn,
                                          gestureDismissal: true)
        editWorkerPopup.addButtons([cancelButton, doneButton])
        editWorkerVC.formatter = formatter
        
        if index < viewModel.count {
        editWorkerVC.viewModel = viewModel.workerViewModels[index]
        }
        
        presentViewController(editWorkerPopup, animated: true, completion: nil)
        
        //        navigationController?.pushViewController(editWorkerVC, animated: true)
        /*guard let workerView = (tableView.cellForRowAtIndexPath(
         NSIndexPath(forRow: viewModelCount, inSection: 0))
         as? EditableTableViewCell)?.workerView else { return }
         
         workerView.nameField.becomeFirstResponder()*/

    }
    
    @IBAction func newWorker() {
        editWorker(atIndex: viewModel.count)
            }
    
    /*func removeAll() {
        (0..<viewModel.count).reverse().forEach {
        viewModel.removeWorkerAtIndex($0)
        }
        tableView.beginUpdates()
        tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        tableView.endUpdates()
//        tableView.reloadData()
    }*/
    
    // MARK: TableViewDelegate/DataSource

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(EditableWorkerTableViewController.workerCellID) as? EditableTableViewCell
            else { fatalError("Expected a EditableTableViewCell") }
        resetPropertiesOfTipoutView(cell.workerView)
        cell.workerView.delegate = self
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? EditableTableViewCell else { fatalError("Expected a EditableTableViewCell; got a \(cell.dynamicType) instead") }
        
        tableViewCell.viewModel = viewModel[indexPath.row]
        tableViewCell.accessibilityLabel = "Worker \(indexPath.item) with name \(tableViewCell.workerView.nameField.text)"
        tableViewCell.accessibilityIdentifier = "worker\(indexPath.item)"
    }
    
    /* override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = viewModel?.count ?? 0
        if rows < showEmptyViewWhenLessThan  /*&& emptyView.hidden == true*/ {
            tableView.scrollEnabled = false
            showEmptyView()
        } else if rows >= showEmptyViewWhenLessThan /*&& emptyView.hidden == false*/ {
            tableView.scrollEnabled = true
            hideEmptyView()
        }
        return rows
    }*/
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }*/
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /*override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            viewModel.removeWorkerAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }*/
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editWorker(atIndex: indexPath.row)
    }*/
    
    // MARK: Empty View
    
    /*func showEmptyView() {
        emptyView.hidden = false
        tableView.bringSubviewToFront(emptyView)
    }*/
    
    /*func hideEmptyView() {
        emptyView.hidden = true
        tableView.sendSubviewToBack(emptyView)
    }*/
    
    // MARK: TipoutView
    
    func tableViewCellForTipoutView(tipoutView: EditableTipoutView) -> EditableTableViewCell? {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? EditableTableViewCell else { fatalError("Wrong cell type. Expected a EditableTableViewCell") }
        
        return cell
    }
    
    func handleInputForTipoutView(tipoutView: EditableTipoutView, activeText: String?) {
        guard let cell = tableViewCellForTipoutView(tipoutView) else { fatalError("Couldn't get tableViewCell") }
        guard let
            indexPath = tableView.indexPathForCell(cell),
            activeText = tipoutView.activeTextField?.text ?? .Some("0"),
            tag = tipoutView.activeTextField?.tag ?? .Some(3), // Amount tag
            textFieldTag = TipoutViewField(rawValue: tag)
        else { return }
        
        viewModel.addWorkerWithName(
            tipoutView.nameField.text ?? "",
            method: textFieldTag,
            value: activeText,
            atIndex: indexPath.row)
        
        cell.viewModel = viewModel[indexPath.row]
    }
    
    func tipoutViewDidBeginEditing(tipoutView: EditableTipoutView, textField: UITextField) {
        guard let
            cell = tableViewCellForTipoutView(tipoutView),
            indexPath = tableView.indexPathForCell(cell)
            else { fatalError("Couldn't get tableViewCell or index") }
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    
    func tipoutViewDidEndEditing(tipoutView: EditableTipoutView) {
        guard let activeField = tipoutView.activeTextField,
            text = activeField.text,
        formatter = formatter else { return }
        switch TipoutViewField(rawValue: activeField.tag) {
        case .Amount?: activeField.text = try? formatter.formatNumberString(text)
        case .Percentage?: activeField.text = try? formatter.formatPercentageString(text, stripSymbol: true)
        case .Hours?: activeField.text = try? formatter.formatNumberString(text)
        case .Name?: break
        case nil: break
            }
    }
    
    func tipoutView(tipoutView: EditableTipoutView, textField: UITextField, textDidChange text: String) {
        handleInputForTipoutView(tipoutView, activeText: text)
    }
    
    func tipoutView(tipoutView: EditableTipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text ?? ""
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
        if !newString.isEmpty {
            do {
                switch TipoutViewField(rawValue: textField.tag) {
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