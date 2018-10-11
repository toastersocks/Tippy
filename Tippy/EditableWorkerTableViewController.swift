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

    func resetPropertiesOfTipoutView(_ view: EditableTipoutView) {
        view.delegate = nil
        view.activeTextField = nil
    }
    
    @IBAction func editWorker(atIndex index: Int) {
        let editWorkerVC = EditWorkerViewController(nibName: "EditWorkerViewController", bundle: nil)
        guard let bundle = Bundle(identifier: "com.apple.UIKit") else { fatalError("Coudn't access bundle") }
        
        let cancelButton = CancelButton(title: bundle.localizedString(forKey: "Cancel", value: "", table: nil), action: nil)
        cancelButton.accessibilityIdentifier = "cancelButton"
        cancelButton.accessibilityLabel = bundle.localizedString(forKey: "Cancel", value: "", table: nil)
        let doneButton = DefaultButton(title: bundle.localizedString(forKey: "Done", value: "", table: nil)) {
            let method: TipoutViewField = {
                switch editWorkerVC.currentMethodIndex {
                case 0: // Hourly
                    return TipoutViewField.hours
                case 1: // Percent
                    return TipoutViewField.percentage
                case 2: // Amount
                    return TipoutViewField.amount
                default:
                    fatalError("Unknown value for tipout method")
                }
            }()
            
            let value = editWorkerVC.currentValue ?? "0"
            
            let viewModelCount = self.viewModel.count
            let name = editWorkerVC.nameField.text ?? ""
            
            self.viewModel.addWorkerWithName(name, method: method, value: value, atIndex: viewModelCount)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: viewModelCount, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
        let editWorkerPopup = PopupDialog(viewController: editWorkerVC,
                                          buttonAlignment: .horizontal,
                                          transitionStyle: .zoomIn,
                                          gestureDismissal: true)
        editWorkerPopup.addButtons([cancelButton, doneButton])
        editWorkerVC.formatter = formatter
        
        if index < viewModel.count {
        editWorkerVC.viewModel = viewModel.workerViewModels[index]
        }
        
        present(editWorkerPopup, animated: true, completion: nil)
        
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditableWorkerTableViewController.workerCellID) as? EditableTableViewCell
            else { fatalError("Expected a EditableTableViewCell") }
        resetPropertiesOfTipoutView(cell.workerView)
        cell.workerView.delegate = self
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? EditableTableViewCell else { fatalError("Expected a EditableTableViewCell; got a \(type(of: cell)) instead") }
        
        tableViewCell.viewModel = viewModel[indexPath.row]
        tableViewCell.accessibilityLabel = "Worker \(indexPath.item) with name \(tableViewCell.workerView.nameField.text ?? "Blank")"
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
    
    func tableViewCellForTipoutView(_ tipoutView: EditableTipoutView) -> EditableTableViewCell? {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? EditableTableViewCell else { fatalError("Wrong cell type. Expected a EditableTableViewCell") }
        
        return cell
    }
    
    func handleInputForTipoutView(_ tipoutView: EditableTipoutView, activeText: String?) {
        guard let cell = tableViewCellForTipoutView(tipoutView) else { fatalError("Couldn't get tableViewCell") }
        guard let
            indexPath = tableView.indexPath(for: cell),
            let activeText = tipoutView.activeTextField?.text ?? .some("0"),
            let tag = tipoutView.activeTextField?.tag ?? .some(3), // Amount tag
            let textFieldTag = TipoutViewField(rawValue: tag)
        else { return }
        
        viewModel.addWorkerWithName(
            tipoutView.nameField.text ?? "",
            method: textFieldTag,
            value: activeText,
            atIndex: indexPath.row)
        
        cell.viewModel = viewModel[indexPath.row]
    }
    
    func tipoutViewDidBeginEditing(_ tipoutView: EditableTipoutView, textField: UITextField) {
        guard let
            cell = tableViewCellForTipoutView(tipoutView),
            let indexPath = tableView.indexPath(for: cell)
            else { fatalError("Couldn't get tableViewCell or index") }
        
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
    
    func tipoutViewDidEndEditing(_ tipoutView: EditableTipoutView) {
        guard let activeField = tipoutView.activeTextField,
            let text = activeField.text,
        let formatter = formatter else { return }
        switch TipoutViewField(rawValue: activeField.tag) {
        case .amount?: activeField.text = try? formatter.formatNumberString(text)
        case .percentage?: activeField.text = try? formatter.formatPercentageString(text, stripSymbol: true)
        case .hours?: activeField.text = try? formatter.formatNumberString(text)
        case .name?: break
        case nil: break
            }
    }
    
    func tipoutView(_ tipoutView: EditableTipoutView, textField: UITextField, textDidChange text: String) {
        handleInputForTipoutView(tipoutView, activeText: text)
    }
    
    func tipoutView(_ tipoutView: EditableTipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text as NSString? ?? ""
        let newString = oldString.replacingCharacters(in: range, with: string)
        if !newString.isEmpty {
            do {
                switch TipoutViewField(rawValue: textField.tag) {
                case .amount?: try _ = formatter?.currencyFromString(newString)
                case .percentage?: _ = try formatter?.percentageFromString(newString)
                case .hours?: try _ = formatter?.formatNumberString(newString)
                case .name?: break
                case nil: break
                }
            } catch {
                return false
            }
        }
        return true
    }
}
