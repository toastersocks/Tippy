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
    // MARK: - Properties
    private static let workersViewSegueID = "workersViewSegue"
    private static let workerCellID = "workerCell"

    weak var workerTableView: UITableView! {
        didSet {
            workerTableView.delegate = self
            workerTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var colorStackView: ColorStackView! {
        didSet {
            colorStackView.delegate = controller
            colorStackView.colorDelegate = ColorDelegate()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalField: UITextField!
    
    @IBOutlet weak var combineButton: UIButton!
    @IBOutlet weak var storeOrDoneButton: UIButton!
    @IBOutlet weak var bottomBarLayoutConstraint: NSLayoutConstraint!
    
    dynamic var controller = Controller()
    
    // MARK: - Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let totalChannel = RACKVOChannel(target: self, keyPath: "controller.currentViewModel.totalText", nilValue: "")["followingTerminal"]
        totalField.rac_newTextChannel().subscribe(totalChannel)
        totalChannel.subscribe(totalField.rac_newTextChannel())
        
        RACObserve(controller, "currentViewModel").subscribeNextAs {
            (_: TipoutViewModelType) -> () in
            self.workerTableView.reloadData()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
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
        
        guard let workerView = (workerTableView.cellForRowAtIndexPath(
            NSIndexPath(forRow: viewModelCount, inSection: 0))
            as? TableViewCell)?.workerView else { return }
        
        workerView.nameField.becomeFirstResponder()

    }
    
    func handleInputForTipoutView(tipoutView: TipoutView, activeText: String?) {
        var aView: UIView = tipoutView
        
        while !(aView is UITableViewCell) {
            aView = aView.superview!
        }
        
        guard let cell = aView as? TableViewCell else { fatalError("Wrong cell type. Expected a TableViewCell") }

        if let indexPath = workerTableView.indexPathForCell(cell) {

            if let activeText = activeText, placeholderText = tipoutView.activeTextField?.placeholder {

                controller.currentViewModel.addWorkerWithName(
                    tipoutView.nameField.text ?? "",
                    method: placeholderText,
                    value: activeText,
                    atIndex: indexPath.row)
                
                cell.viewModel = controller.currentViewModel[indexPath.row]
            }
        }
    }
    
    func resetPropertiesOfTipoutView(view: TipoutView) {
        view.delegate = nil
        view.activeTextField = nil
    }
    
    
    @IBAction func storeTapped(sender: UIButton) {
        controller.storeCurrent()
        colorStackView.reload()
    }
    
    @IBAction func combine(sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewControllerWithIdentifier("tipoutvc") as? ViewController else { fatalError("Unable to instantiate ViewController") }
        
        presentViewController(viewController, animated: true, completion: nil)

        viewController.storeOrDoneButton.setTitle("Done", forState: .Normal)
        viewController.storeOrDoneButton.removeTarget(viewController, action: "storeTapped:", forControlEvents: .TouchUpInside)
        viewController.storeOrDoneButton.addTarget(viewController, action: "done:", forControlEvents: .TouchUpInside)
        viewController.combineButton.hidden = true
        if let combinedTipoutViewModel = controller.combinedTipoutsViewModel() {
            debugPrint(combinedTipoutViewModel.totalText)
            viewController.controller = Controller(tipoutViewModel: combinedTipoutViewModel)
        } else {
            
        }
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        resetPropertiesOfTipoutView(cell.workerView)
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            workerTableView.beginUpdates()
            controller.currentViewModel.removeWorkerAtIndex(indexPath.row)
            workerTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            workerTableView.endUpdates()
        }
    }
    
    // MARK: TipoutView
    
    func tipoutViewDidEndEditing(tipoutView: TipoutView) {
        handleInputForTipoutView(tipoutView, activeText: tipoutView.activeTextField?.text)
            }
    
    func tipoutView(tipoutView: TipoutView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString? = tipoutView.activeTextField?.text
        let proposedText = currentText?.stringByReplacingCharactersInRange(range, withString: string)
        handleInputForTipoutView(tipoutView, activeText: proposedText)
        return true
    }
    
    // MARK: - Keyboard Observers
    
    func keyboardWasShown(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let kbSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else { fatalError("Couldn't get keyboard size") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = -kbSize.height
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = 0
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

