//
//  StaticWorkerTVC.swift
//  Tippy
//
//  Created by James Pamplona on 11/15/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit
import PopupDialog

class StaticWorkerTVC: WorkerTableViewController {
    
    static let workerCellID = "staticWorkerCell"
    
    /*var viewModel: TipoutViewModelType! {
        didSet {
            tableView.reloadData()
        }
    }*/
    
    /*var emptyView: EmptyView = EmptyView()
    var showEmptyViewWhenLessThan = 1
    var formatter: Formatter?*/
    
    /*override func viewDidLoad() {
        
        // These two lines are nessesary so table view cells don't overlap
        // over each other on iOS 8.1 & 8.2
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView = emptyView
        hideEmptyView()

        super.viewDidLoad()
        }*/
    
    /*func hideEmptyView() {
        emptyView.hidden = true
        tableView.sendSubviewToBack(emptyView)
    }*/

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
         as? TableViewCell)?.workerView else { return }
         
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


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StaticWorkerTVC.workerCellID) as? StaticTableViewCell
            else { fatalError("Expected a StaticTableViewCell") }
//        resetPropertiesOfTipoutView(cell.workerView)
//        cell.workerView.delegate = self
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? StaticTableViewCell else { fatalError("Expected a StaticTableViewCell; got a \(type(of: cell)) instead") }
        
        tableViewCell.viewModel = viewModel[indexPath.row]
        tableViewCell.accessibilityLabel = "Worker \(indexPath.item) with name \(tableViewCell.workerView.nameLabel.text)"
        tableViewCell.accessibilityIdentifier = "worker\(indexPath.item)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editWorker(atIndex: indexPath.row)
    }
    
    // MARK: = TipoutView
    
    func tableViewCellForTipoutView(_ tipoutView: StaticTipoutView) -> StaticTableViewCell? {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? StaticTableViewCell else { fatalError("Wrong cell type. Expected a StaticTableViewCell") }
        
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
