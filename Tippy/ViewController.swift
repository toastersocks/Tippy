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
import Gecco
import Chameleon


class ViewController: UIViewController {
    // MARK: - Properties
    private static let workersViewSegueID = "workersViewSegue"
    private static let colorStackSegueID = "colorStackSegue"
    
    weak var workerTableViewController: WorkerTableViewController!
    
    @IBOutlet weak var colorStackViewController: ColorStackViewController!
    
    @IBOutlet weak var upperToolbar: UIToolbar!
    var colorDelegate: ColorDelegate? = ColorDelegate()
    
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var splitButton: UIButton!
//    @IBOutlet weak var clearButton: UIButton!
//    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var settingsBarButton: UIButton!
    @IBOutlet weak var combineOrDoneButton: UIButton! {
        didSet {
            combineOrDoneButton.addTarget(self, action: .combine, forControlEvents: .TouchUpInside)
        }
    }
    @IBOutlet weak var storeButton: UIButton! {
        didSet {
            storeButton.addTarget(self, action: .store, forControlEvents: .TouchUpInside)
        }
    }
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.addTarget(self, action: .clear, forControlEvents: .TouchUpInside)
        }
    }
    
    @IBOutlet weak var clearAllButton: UIButton! {
        didSet {
            clearAllButton.addTarget(self, action: .clearAll, forControlEvents: .TouchUpInside)
        }
    }
    
    @IBOutlet weak var bottomBarLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var iPhone4SColorStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var numberFormatter: Formatter? {
        didSet {
            Defaults.rac_channelTerminalForKey(DefaultsKeys.percentageFormat._key).subscribeNextAs {
                (option: Int) -> () in
                self.numberFormatter?.percentFormat = option == 0 ? .Decimal : .WholeNumber
            }
        }
    }
    dynamic var controller: Controller = Controller()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        colorStackViewController.delegate = controller
//        colorStackViewController.colorDelegate = colorDelegate
        controller.colorStack = colorDelegate
        controller.numberFormatter = numberFormatter
//        colorStackViewController.reload()
        
        // Total Field
        
        numberFormatter?.configureAmountTextfield(&totalField!)
        

        let totalSignal = RACObserve(self, "controller.currentViewModel.totalText")
        
        totalField.rac_textSignal().subscribeNextAs({ (text: NSString) -> () in
            self.controller.currentViewModel.totalText = text as String
            self.workerTableViewController.tableView.reloadData()
        })
        totalSignal.subscribeNextAs { (text: NSString) -> () in
            self.totalField.text = text as String
        }
        
        // ViewModel
        RACObserve(self, "controller.currentViewModel").subscribeNextAs {
            (viewModel: TipoutViewModelType) -> () in
            self.workerTableViewController?.viewModel = viewModel
        }
        
        // Color
        RACObserve(self, "controller.currentColor").subscribeNextAs {
            (color: UIColor) in
//            Chameleon.setGlobalThemeUsingPrimaryColor(color, withContentStyle: .Contrast)
//            self.containerView.backgroundColor = color.colorWithAlphaComponent(0.25)
            let color = color
            
            self.workerTableViewController.view.backgroundColor = color.colorWithAlphaComponent(0.25)
            self.upperToolbar.barTintColor = color.colorWithAlphaComponent(0.25)
            self.bottomBar.backgroundColor = color.colorWithAlphaComponent(0.25)
//            self.bottomBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color.colorWithAlphaComponent(0.25), isFlat: true)
            self.upperToolbar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: self.upperToolbar.barTintColor, isFlat: true)
//            self.setThemeUsingPrimaryColor(color, withContentStyle: .Contrast)
//            self.workerTableViewController.setThemeUsingPrimaryColor(color, withContentStyle: .Contrast)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .keyboardWillShow, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .keyboardWillHide, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        Defaults.rac_channelTerminalForKey(DefaultsKeys.showWalkthrough._key).subscribeNextAs {
            (showWalkthrough: Bool) -> () in
            if showWalkthrough {
                self.showWalkthrough()
            }
        }

    }
    
    func showWalkthrough() {
        let walkthroughController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Walkthrough") as! WalkthroughViewController
        walkthroughController.views = [storeButton, combineOrDoneButton, settingsBarButton, splitButton, clearButton, clearAllButton, colorStackViewController.view]
        walkthroughController.alpha = 0.5
        self.presentViewController(walkthroughController, animated: true) {
            Defaults[.showWalkthrough] = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func store() {
        controller.storeCurrent()
        colorStackViewController.increment()
//        colorStackViewController.reload()
    }
    
    @IBAction func clear(sender: UIButton) {
        controller.removeCurrent()
        colorStackViewController.reload()
    }
    
    @IBAction func clearAll(sender: UIButton) {
        controller.removeAll()
        colorStackViewController.reload()
    }
    
    @IBAction func combine() {
        guard let viewController = storyboard?.instantiateViewControllerWithIdentifier("tipoutvc") as? ViewController else { fatalError("Unable to instantiate ViewController") }
        
        presentViewController(viewController, animated: true, completion: nil)
        let combinedTipoutViewModel = controller.combinedTipoutsViewModel()
        viewController.controller = Controller(tipoutViewModel: combinedTipoutViewModel, numberFormatter: numberFormatter)
        controller.colorStack = colorDelegate
//        viewController.storeOrDoneButton.title = "Done"
        viewController.combineOrDoneButton.setTitle(NSBundle(identifier: "com.apple.UIKit")?.localizedStringForKey("Done", value: "", table: nil), forState: .Normal)
        viewController.combineOrDoneButton.removeTarget(viewController, action: .store, forControlEvents: .TouchUpInside)
        viewController.combineOrDoneButton.addTarget(viewController, action: .done, forControlEvents: .TouchUpInside)
//        viewController.combineOrDoneButton.target = viewController
//        viewController.combineOrDoneButton.action = "done"
//        viewController.combineButton.hidden = true
        viewController.storeButton.enabled = false

//            debugPrint(combinedTipoutViewModel.totalText)
    
    }
    
    @IBAction func split() {
        let alertView = SwiftAlertView(nibName: "SplitAmountView", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "Split")
        (alertView.contentView as! SplitAmountView).formatter = numberFormatter
        alertView.clickedOtherButtonAction = {
            (buttonIndex: Int) in
            switch buttonIndex {
            case 0: // Cancel
                break
            case 1: // Split
                guard let splitAmountView = alertView.contentView as? SplitAmountView else { return }
                let splitMethod = splitAmountView.splitMethod

                // If amount is zero, there's nothing to split
                if case let .Amount(amount) = splitMethod where amount == 0.0 {
                    return
                } else if case let .Percentage(amount) = splitMethod where amount == 0.0 {
                    return
                }
                
                self.controller.split(by: splitAmountView.splitMethod)
            default:
                return
            }
            
            self.colorStackViewController.reload()
            print("Button index is \(buttonIndex)")
        }
        
        
        alertView.show()
    }
    
    @IBAction func done() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ViewController.workersViewSegueID {
            guard let workerTVC = segue.destinationViewController as? WorkerTableViewController else { return }
            
            let tableViewCellNib = UINib(nibName: "TableViewCell", bundle: NSBundle.mainBundle())
            workerTVC.tableView.registerNib(tableViewCellNib, forCellReuseIdentifier: WorkerTableViewController.workerCellID)
            workerTableViewController = workerTVC
            workerTableViewController.tableView.panGestureRecognizer.delaysTouchesBegan = true
            workerTableViewController.formatter = numberFormatter
        } else if segue.identifier == ViewController.colorStackSegueID {
            guard let colorStackVC = segue.destinationViewController as? ColorStackViewController else { return }
            controller.colorStack = colorDelegate
            colorStackViewController = colorStackVC
            colorStackViewController.colorDelegate = colorDelegate
            colorStackViewController.delegate = controller
            colorStackViewController.reload()
        }
        
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            showWalkthrough()
        }
    }
    
    // MARK: - Keyboard Observers
    
    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let kbSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else { fatalError("Couldn't get keyboard size") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = -kbSize.height
        UIView.animateWithDuration(animationDuration) {
            self.bottomBar.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { fatalError("Couldn't get keyboard animation duration") }
//        self.view.layoutIfNeeded()
        self.bottomBarLayoutConstraint.constant = 0
        UIView.animateWithDuration(animationDuration) {
            self.bottomBar.layoutIfNeeded()
        }
    }
}

private extension Selector {
    static let combine = #selector(ViewController.combine)
    static let store = #selector(ViewController.store)
    static let done = #selector(ViewController.done)
    static let clear = #selector(ViewController.clear(_:))
    static let clearAll = #selector(ViewController.clearAll(_:))
    static let keyboardWillShow = #selector(ViewController.keyboardWillShow(_:))
    static let keyboardWillHide = #selector(ViewController.keyboardWillHide(_:))
    
}


