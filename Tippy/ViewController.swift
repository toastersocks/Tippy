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
import PopupDialog


class ViewController: UIViewController {
    // MARK: - Properties
    private static let editableWorkersViewSegueID = "editableWorkersViewSegue"
    private static let staticWorkersViewSegueID = "staticWorkersViewSegue"
    private static let colorStackSegueID = "colorStackSegue"
    private static let settingsViewControllerID = "settingsSegue"
    
    weak var workerTableViewController: WorkerTableViewController!
    
//    @IBOutlet weak var colorStackContainerView: UIView!
    
//    @IBOutlet weak var colorStackViewController: ColorStackViewController!
    
    @IBOutlet weak var upperToolbar: UIToolbar!
//    var colorDelegate: ColorDelegate? = ColorDelegate()
    
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var splitButton: UIButton!
    //    @IBOutlet weak var clearButton: UIButton!
    //    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var settingsBarButton: UIButton!
    
    @IBOutlet weak var newButton: UIButton! {
        didSet {
            newButton.addTarget(self, action: .new, for: .touchUpInside)
        }
    }
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.addTarget(self, action: .clear, for: .touchUpInside)
        }
    }
    
    /*@IBOutlet weak var clearAllButton: UIButton! {
        didSet {
            clearAllButton.addTarget(self, action: .clearAll, forControlEvents: .TouchUpInside)
        }
    }*/
    
    @IBOutlet weak var bottomBarLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var numberFormatter: Formatter? {
        didSet {
            Defaults.rac_channelTerminal(forKey: DefaultsKeys.percentageFormat._key).subscribeNextAs {
                (option: Int) -> () in
                self.numberFormatter?.percentFormat = option == 0 ? .decimal : .wholeNumber
            }
        }
    }
    
    
    
    /*dynamic var viewModel: TipoutViewModelType? {
        didSet {
            totalField?.text = viewModel?.totalText
            workerTableViewController.viewModel = viewModel
        }
    }*/
    
    dynamic var color = UIColor.clear
    dynamic var controller: Controller = Controller()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        controller.colorStack = colorDelegate
        controller.numberFormatter = numberFormatter
        
        // Total Field
        
        numberFormatter?.configureAmountTextfield(&totalField!)
        
        
        let totalSignal = RACObserve(self, "controller.currentViewModel.totalText")
        
        totalField.rac_textSignal().skip(1).subscribeNextAs({ (text: NSString) -> () in
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
            
            self.workerTableViewController.view.backgroundColor = color.withAlphaComponent(0.25)
            self.upperToolbar.barTintColor = color.withAlphaComponent(0.25)
            self.bottomBar.backgroundColor = color.withAlphaComponent(0.25)
            //            self.bottomBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color.colorWithAlphaComponent(0.25), isFlat: true)
            self.upperToolbar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: self.upperToolbar.barTintColor, isFlat: true)
            //            self.setThemeUsingPrimaryColor(color, withContentStyle: .Contrast)
            //            self.workerTableViewController.setThemeUsingPrimaryColor(color, withContentStyle: .Contrast)
            self.workerTableViewController.emptyView.tintColor = color
        }
        
        // Workers
        RACObserve(self, "controller.currentViewModel.workerViewModels").subscribeNextAs {
            (workerViewModels: AnyObject) -> () in
            self.workerTableViewController.tableView.reloadData()
        }
        
        // Settings
        
        Defaults.rac_channelTerminal(forKey: DefaultsKeys.percentageFormat._key).subscribeNext {
            (_: AnyObject!) -> Void in
            self.workerTableViewController.tableView.reloadData()
        }
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Defaults.rac_channelTerminal(forKey: DefaultsKeys.showWalkthrough._key).subscribeNextAs {
            (showWalkthrough: Bool) -> () in
            if showWalkthrough && !isUITest() {
                self.showWalkthrough()
            }
        }
        
    }
    
    func showWalkthrough() {
        let walkthroughController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Walkthrough") as! WalkthroughViewController
        walkthroughController.views = [newButton, /*combineOrDoneButton,*/ settingsBarButton, splitButton, clearButton, /*clearAllButton,*/ /*workerTableViewController.addNewButton*/]
        walkthroughController.alpha = 0.5
        self.present(walkthroughController, animated: true) {
            Defaults[.showWalkthrough] = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func new() {
        controller.new()
//        colorStackViewController.increment()
    }
    
    @IBAction func clear(_ sender: UIButton) {
//        let index = controller.currentIndex
//        controller.removeCurrent()
        workerTableViewController.removeAll()
        
        /*if controller.count == 1 {
//            colorStackViewController.reload()
        } else {
//            colorStackViewController.removeItemAtIndex(index)
        }*/
    }
    
    /*@IBAction func clearAll(sender: UIButton) {
        controller.removeAll()
//        colorStackViewController.reload()
    }*/
    
    /*@IBAction func combine() {
        guard let viewController = storyboard?.instantiateViewControllerWithIdentifier("tipoutvc") as? ViewController else { fatalError("Unable to instantiate ViewController") }
        let bundle = NSBundle(identifier: "com.apple.UIKit")
        presentViewController(viewController, animated: true, completion: nil)
        let combinedTipoutViewModel = controller.combinedTipoutsViewModel()
        let newController = Controller(tipoutViewModel: combinedTipoutViewModel, numberFormatter: numberFormatter)
        
        viewController.controller = newController
//        viewController.colorStack = controller.colorStack
        viewController.combineOrDoneButton.setTitle(bundle?.localizedStringForKey("Done", value: "", table: nil), forState: .Normal)
        viewController.combineOrDoneButton.removeTarget(viewController, action: .new, forControlEvents: .TouchUpInside)
        viewController.combineOrDoneButton.addTarget(viewController, action: .done, forControlEvents: .TouchUpInside)
        viewController.newButton.enabled = false
        
        //            debugPrint(combinedTipoutViewModel.totalText)
        
    }*/
    
    @IBAction func split() {
        guard let bundle = Bundle(identifier: "com.apple.UIKit") else { fatalError("Couln't access bundle") }
        let splitController = SplitAmountViewController(nibName: "SplitAmountView", bundle: nil)
        let cancelButton: CancelButton = {
            $0.accessibilityIdentifier = "cancelButton"
            $0.accessibilityLabel = NSLocalizedString("Cancel", comment: "Cancels the action")
            return $0
        }(CancelButton(title: bundle.localizedString(forKey: "Cancel", value: "", table: nil), action: nil))
        
        let splitButton: DefaultButton = {
            $0.accessibilityIdentifier = "splitButton"
            $0.accessibilityLabel = NSLocalizedString("Split", comment: "Split an amount of currency")
            return $0
            }(DefaultButton(title: NSLocalizedString("Split", comment: "Split an amount of currency")) {
                
                
                let splitMethod = splitController.splitMethod
                
                // If amount is zero, there's nothing to split
                if case let .amount(amount) = splitMethod, amount == 0.0 {
                    return
                } else if case let .percentage(amount) = splitMethod, amount == 0.0 {
                    return
                }
                
                self.controller.split(by: splitController.splitMethod)
                self.controller.selectViewModel(self.controller.currentIndex + 1)
                })
        
        let alertView = PopupDialog(viewController: splitController,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    gestureDismissal: true)
        
        alertView.addButtons([cancelButton, splitButton])
        
        splitController.formatter = numberFormatter
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func done() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case ViewController.editableWorkersViewSegueID?:
            guard let workerTVC = segue.destination as? EditableWorkerTableViewController else { fatalError("Couldn't access editable worker table view controller") }
            
            let tableViewCellNib = UINib(nibName: "EditableTableViewCell", bundle: Bundle.main)
            workerTVC.tableView.register(tableViewCellNib, forCellReuseIdentifier: EditableWorkerTableViewController.workerCellID)
            workerTableViewController = workerTVC
            workerTableViewController.tableView.panGestureRecognizer.delaysTouchesBegan = true
            workerTableViewController.formatter = numberFormatter
            
        case ViewController.staticWorkersViewSegueID?:
            
            guard let workerTVC = segue.destination as? StaticWorkerTVC else { fatalError("Couldn't access worker table view controller") }
            
            let tableViewCellNib = UINib(nibName: "StaticTableViewCell", bundle: Bundle.main)
            workerTVC.tableView.register(tableViewCellNib, forCellReuseIdentifier: StaticWorkerTVC.workerCellID)
            workerTableViewController = workerTVC
            workerTableViewController.tableView.panGestureRecognizer.delaysTouchesBegan = true
            workerTableViewController.formatter = numberFormatter

        
        case ViewController.settingsViewControllerID?:
            guard let navVC = segue.destination as? UINavigationController,
                let settingsVC = navVC.topViewController as? SettingsTableViewController else { fatalError("Couldn't access settings table view controller") }
            settingsVC.formatter = numberFormatter

        default:
            fatalError("Unknown destination view controller")
        }
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showWalkthrough()
        }
    }
    
    // MARK: - Keyboard Observers
    
    func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size else { fatalError("Couldn't get keyboard size") }
        guard let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        bottomBarLayoutConstraint.constant = -kbSize.height
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomBar.layoutIfNeeded()
        }) 
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard let info = notification.userInfo else { fatalError("Couldn't get info dictionary from notification") }
        guard let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { fatalError("Couldn't get keyboard animation duration") }
        //        self.view.layoutIfNeeded()
        self.bottomBarLayoutConstraint.constant = 0
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomBar.layoutIfNeeded()
        }) 
    }
}

// MARK: -
private extension Selector {
//    static let combine = #selector(ViewController.combine)
    static let new = #selector(ViewController.new)
    static let done = #selector(ViewController.done)
    static let clear = #selector(ViewController.clear(_:))
//    static let clearAll = #selector(ViewController.clearAll(_:))
    static let keyboardWillShow = #selector(ViewController.keyboardWillShow(_:))
    static let keyboardWillHide = #selector(ViewController.keyboardWillHide(_:))
    
}


