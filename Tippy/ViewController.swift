//
//  ViewController.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftyUserDefaults


class ViewController: UIViewController {
    // MARK: - Properties
    private static let workersViewSegueID = "workersViewSegue"
    
    weak var workerTableViewController: WorkerTableViewController!
    
    @IBOutlet weak var colorStackView: ColorStackView! {
        didSet {
            colorStackView.delegate = controller
            colorStackView.colorDelegate = ColorDelegate()
        }
    }
    
    @IBOutlet weak var totalField: UITextField!
    
    @IBOutlet weak var combineButton: UIButton!
    @IBOutlet weak var storeOrDoneButton: UIButton!
    @IBOutlet weak var bottomBarLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numberFormatter: Formatter? {
        didSet {
            Defaults.rac_channelTerminalForKey(DefaultsKeys.percentageFormat._key).subscribeNextAs {
                (option: Int) -> () in
                self.numberFormatter?.percentFormat = option == 0 ? .Decimal : .WholeNumber
            }
            controller = Controller(numberFormatter: numberFormatter)
        }
    }
    dynamic var controller: Controller
    
    required init?(coder aDecoder: NSCoder) {
        controller = Controller() 
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Total
        let totalChannel = RACKVOChannel(target: self, keyPath: "controller.currentViewModel.totalText", nilValue: "")["followingTerminal"]
        totalField.rac_newTextChannel().subscribe(totalChannel)
        totalChannel.subscribe(totalField.rac_newTextChannel())
        
        // ViewModel
        RACObserve(self, "controller.currentViewModel").subscribeNextAs {
            (viewModel: TipoutViewModelType) -> () in
            self.workerTableViewController?.viewModel = viewModel
        }
        
        // Workers
        RACObserve(self, "controller.currentViewModel.workerViewModels").subscribeNextAs {
            (workerViewModels: AnyObject) -> () in
            self.workerTableViewController.tableView.reloadData()
        }
        
        // Settings
        Defaults.rac_channelTerminalForKey(DefaultsKeys.percentageFormat._key).subscribeNext {
            (_: AnyObject!) -> Void in
            self.workerTableViewController.tableView.reloadData()
        }
        
        // Keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func storeTapped(sender: UIBarButtonItem) {
        controller.storeCurrent()
        colorStackView.reload()
    }
    
    @IBAction func combine(sender: UIBarButtonItem) {
        guard let viewController = storyboard?.instantiateViewControllerWithIdentifier("tipoutvc") as? ViewController else { fatalError("Unable to instantiate ViewController") }
        
        presentViewController(viewController, animated: true, completion: nil)
        
        viewController.storeOrDoneButton.setTitle("Done", forState: .Normal)
        viewController.storeOrDoneButton.removeTarget(viewController, action: "storeTapped:", forControlEvents: .TouchUpInside)
        viewController.storeOrDoneButton.addTarget(viewController, action: "done:", forControlEvents: .TouchUpInside)
        viewController.combineButton.hidden = true
        if let combinedTipoutViewModel = controller.combinedTipoutsViewModel() {
            debugPrint(combinedTipoutViewModel.totalText)
            viewController.controller = Controller(tipoutViewModel: combinedTipoutViewModel, numberFormatter: numberFormatter)
        } else {
            
        }
    }
    
    @IBAction func done(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ViewController.workersViewSegueID {
            guard let workerTVC = segue.destinationViewController as? WorkerTableViewController else { return }
            
            let tableViewCellNib = UINib(nibName: "TableViewCell", bundle: NSBundle.mainBundle())
            workerTVC.tableView.registerNib(tableViewCellNib, forCellReuseIdentifier: WorkerTableViewController.workerCellID)
            workerTableViewController = workerTVC
            
            workerTableViewController.formatter = numberFormatter
        }
    }
    
    // MARK: - Keyboard Observers
    
    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let kbSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else { fatalError("Couldn't get keyboard size") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = -kbSize.height
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = 0
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}



