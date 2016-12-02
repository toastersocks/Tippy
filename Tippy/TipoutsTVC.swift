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
        Defaults.rac_channelTerminal(forKey: DefaultsKeys.percentageFormat._key).subscribeNextAs {
            (option: Int) -> () in
            formatter.percentFormat = option == 0 ? .decimal : .wholeNumber
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

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func new(_ sender: AnyObject) {
        controller.new()
        tableView.insertRowsAtIndexPaths([IndexPath(forRow: controller.currentIndex, inSection: 0)], withRowAnimation: .Left)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controller.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TipoutsTVC.tipoutCellID, for: indexPath) as? TipoutCell else { fatalError("Coudn't get cell") }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            controller.remove(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller.selectViewModel(indexPath.row)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
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
