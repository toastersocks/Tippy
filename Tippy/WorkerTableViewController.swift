//
//  WorkerTableViewController.swift
//  Tippy
//
//  Created by James Pamplona on 11/16/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class WorkerTableViewController: UITableViewController {

    var emptyView: EmptyView = EmptyView()
    var showEmptyViewWhenLessThan = 1
    var formatter: Formatter?
    
    var viewModel: TipoutViewModelType! {
        didSet {
            tableView.reloadData()
        }
    }
    
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

    func hideEmptyView() {
        emptyView.isHidden = true
        tableView.sendSubview(toBack: emptyView)
    }
    
    func showEmptyView() {
        emptyView.isHidden = false
        tableView.bringSubview(toFront: emptyView)
    }
    
    func removeAll() {
        (0..<viewModel.count).reversed().forEach {
            viewModel.removeWorkerAtIndex($0)
        }
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
        tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        tableView.endUpdates()
        //        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = viewModel?.count ?? 0
        if rows < showEmptyViewWhenLessThan  /*&& emptyView.hidden == true*/ {
            tableView.isScrollEnabled = false
            showEmptyView()
        } else if rows >= showEmptyViewWhenLessThan /*&& emptyView.hidden == false*/ {
            tableView.isScrollEnabled = true
            hideEmptyView()
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.removeWorkerAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
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
