//
//  SettingsTableViewController.swift
//  Tippy
//
//  Created by James Pamplona on 10/28/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftyUserDefaults

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var percentageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var percentageExampleLabel: UITextField! {
        didSet {
            percentageExampleLabel.userInteractionEnabled = false
            percentageExampleLabel.enabled = false
            formatter?.configurePercentTextfield(&percentageExampleLabel!)
        }
    }
    
    @IBOutlet weak var roundToNearest: UITextField! {
        didSet {
            formatter?.configureAmountTextfield(&roundToNearest!)
        }
    }
    
    var formatter: Formatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load
        percentageSegmentedControl.selectedSegmentIndex = Defaults[.percentageFormat] ?? 0
        roundToNearest.text = "\(Defaults[.roundToNearest])"
        // Subscribe to new values
        percentageSegmentedControl.rac_newSelectedSegmentIndexChannelWithNilValue(0).subscribeNextAs {
            (option: Int) -> () in
            Defaults[.percentageFormat] = option
            //TODO: update the example label
        }
        Defaults.rac_channelTerminalForKey("percentageFormat").subscribeNextAs {
            (option: Int) -> () in
            self.percentageExampleLabel.text = try? self.formatter?.percentageStringFromNumber(0.3) ?? "0.3"
        }
        roundToNearest.rac_newTextChannel().mapAs {
            (text: NSString) -> AnyObject in
            return text.doubleValue
        }.subscribeNextAs {
            (nearest: Double) -> () in
            Defaults[.roundToNearest] = nearest
        }
        
    }

    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

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
