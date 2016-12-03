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
import LicensesViewController
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    fileprivate let feedbackEmail = "tippyApp@toastersocks.com"
    fileprivate let acknowledgementsSegueID = "acknowledgements"
    fileprivate let feedbackSegueID = "feedback"
    fileprivate let feedbackEmailSubject = "Feedback on Tippy"
    
    static var feedbackVC = MFMailComposeViewController()
    
    @IBOutlet weak var percentageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var percentageExampleLabel: UITextField! {
        didSet {
            percentageExampleLabel.isUserInteractionEnabled = false
            percentageExampleLabel.isEnabled = false
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
        percentageSegmentedControl.rac_newSelectedSegmentIndexChannel(withNilValue: 0).subscribeNextAs {
            (option: Int) -> () in
            Defaults[.percentageFormat] = option
            //TODO: update the example label
        }
        Defaults.rac_channelTerminal(forKey: "percentageFormat").subscribeNextAs {
            (option: Int) -> () in
            self.percentageExampleLabel.text = try? self.formatter?.percentageStringFromNumber(0.3, stripSymbol: true) ?? "0.3"
        }
        roundToNearest.rac_newTextChannel().mapAs {
            (text: NSString) -> AnyObject in
            return text.doubleValue as AnyObject
        }.subscribeNextAs {
            (nearest: Double) -> () in
            Defaults[.roundToNearest] = nearest
        }
        
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else { fatalError("No segue id found") }
        switch segueID {
        case acknowledgementsSegueID:
            guard let licencesVC = segue.destination as? LicensesViewController else { fatalError("Couldn't get view controller") }
            licencesVC.loadPlist(Bundle.main, resourceName: "Licences")
        case feedbackSegueID:
            if MFMailComposeViewController.canSendMail() {
            guard let feedbackVC = segue.destination as? MFMailComposeViewController else { fatalError("Couldn't get view controller") }
                feedbackVC.mailComposeDelegate = self
                feedbackVC.setToRecipients([feedbackEmail])
                feedbackVC.setSubject(feedbackEmailSubject)
            } else {
                //TODO: Compose a mailto: url to open with another email app
                print("Composing a mailto: url... send to app!")
            }
        default:
            fatalError("Unknown segue ID")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {

            if MFMailComposeViewController.canSendMail() {
//                guard let feedbackVC = segue.destinationViewController as? MFMailComposeViewController else { fatalError("Couldn't get view controller") }
                let feedbackVC = SettingsTableViewController.feedbackVC
                feedbackVC.mailComposeDelegate = self
                feedbackVC.setToRecipients([feedbackEmail])
                feedbackVC.setSubject(feedbackEmailSubject)
                present(feedbackVC, animated: true, completion: nil)
            } else {
                //TODO: Compose a mailto: url to open with another email app
                print("Composing a mailto: url... send to app!")
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        SettingsTableViewController.feedbackVC = MFMailComposeViewController()
    }

    
}
