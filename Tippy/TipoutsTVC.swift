//
//  TipoutsTVC.swift
//  Tippy
//
//  Created by James Pamplona on 9/23/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import ReactiveCocoa

class TipoutsTVC: UITableViewController {
    static let tipoutCellID = "tipoutCell"
    static let tipoutViewControllerID = "tipoutViewController"

    var controller = Controller()
    var formatter: Formatter = {
        let formatter = Formatter()
        Defaults.rac_channelTerminalForKey(DefaultsKeys.percentageFormat._key).subscribeNextAs {
            (option: Int) -> () in
            formatter.percentFormat = option == 0 ? .Decimal : .WholeNumber
        }
        return formatter
    }()
    
    var colorStack = ColorDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.numberFormatter = formatter
        controller.colorStack = colorStack

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func new(sender: AnyObject) {
        controller.new()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: controller.currentIndex, inSection: 0)], withRowAnimation: .Left)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controller.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(TipoutsTVC.tipoutCellID, forIndexPath: indexPath) as? TipoutCell else { fatalError("Coudn't get cell") }
        cell.totalLabel.text = controller.tipoutViewModels[indexPath.row].totalText
        cell.tipoutIcon.backgroundColor = controller.colorStack?.colorForIndex(indexPath.row)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            controller.remove(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        controller.selectViewModel(indexPath.row)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let vc as ViewController:
            
            vc.controller = controller
//            vc.viewModel = controller.currentViewModel
            
        case is SettingsTableViewController:
            break
        default:
            fatalError("Don't know how to handle view controller")
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
