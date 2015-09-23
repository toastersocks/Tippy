//
//  ViewController.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, TipoutViewDelegate {
    
    private static let workersViewSegueID = "workersViewSegue"
    private static let workerCellID = "workerCell"

    weak var workerTableView: UITableView! {
        didSet {
            workerTableView.delegate = self
            workerTableView.dataSource = self
        }
    }
    @IBOutlet weak var totalField: UITextField!
    
    let controller = Controller()
    
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()
        let totalChannel = RACKVOChannel(target: controller, keyPath: "currentViewModel.totalText", nilValue: "")["followingTerminal"]
        totalField.rac_newTextChannel().subscribe(totalChannel)
        totalChannel.subscribe(totalField.rac_newTextChannel())
        
        RACObserve(controller, "currentViewModel").subscribeNextAs {
            (_: TipoutViewModel) -> () in
            self.workerTableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
  
    func newWorker() {
        let viewModelCount = controller.currentViewModel.count
        workerTableView.beginUpdates()
        workerTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: viewModelCount, inSection: 0)], withRowAnimation: .Automatic)
        controller.currentViewModel.addWorkerWithName("", method: "amount", value: "0.0", atIndex: viewModelCount)
        workerTableView.endUpdates()
    }
    
    func handleInputForTipoutView(tipoutView: TipoutView) {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? TableViewCell else { fatalError("Wrong cell type. Expected a TableViewCell") }

        if let indexPath = workerTableView.indexPathForCell(cell) {

            if let activeText = tipoutView.activeTextField?.text, placeholderText = tipoutView.activeTextField?.placeholder {

                controller.currentViewModel.addWorkerWithName(
                    tipoutView.nameField.text ?? "",
                    method: placeholderText,
                    value: activeText,
                    atIndex: indexPath.row)
                
                cell.viewModel = controller.currentViewModel[indexPath.row]
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ViewController.workersViewSegueID {
            let workerTVC = segue.destinationViewController as! WorkerTableViewController
            workerTableView = workerTVC.tableView
            workerTVC.addNewButton.addTarget(self, action: "newWorker", forControlEvents: .TouchUpInside)
            let tableViewCellNib = UINib(nibName: "TableViewCell", bundle: NSBundle.mainBundle())
            workerTableView.registerNib(tableViewCellNib, forCellReuseIdentifier: ViewController.workerCellID)
        }
    }
    
    // MARK: Delegate Methods -
    
    // MARK: DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = workerTableView.dequeueReusableCellWithIdentifier(ViewController.workerCellID) as? TableViewCell
            else { fatalError("Expected a TableViewCell") }

        cell.workerView.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { fatalError("Expected a TableViewCell; got a \(cell.dynamicType) instead") }
        
        tableViewCell.viewModel = controller.currentViewModel[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.currentViewModel.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: TipoutView
    
    func tipoutViewDidEndEditing(tipoutView: TipoutView) {
        handleInputForTipoutView(tipoutView)
            }
    
    func tipoutView(tipoutView: TipoutView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        handleInputForTipoutView(tipoutView)
        return true
    }
    
}

