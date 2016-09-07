//
//  SplitAmountViewController.swift
//  Tippy
//
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

public enum Split {
    case Amount(Double)
    case Percentage(Double)
}

class SplitAmountViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var splitMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var methodAmountField: UITextField!
    
    var splitMethod: Split {
        guard let text = methodAmountField.text else { return .Amount(0.0) }
        
        switch splitMethodSegmentedControl.selectedSegmentIndex {
        case 0: // Amount
            return .Amount((try? formatter?.currencyFromString(text))??.doubleValue ?? Double(text) ?? 0.0)
        case 1: // Percentage
            return .Percentage((try? formatter?.percentageFromString(text))??.doubleValue ?? 0.0)
        default:
            fatalError("Unimplemented option")
        }
    }
    
    var formatter: Formatter? {
        didSet {
            splitMethodSegmentedControl.rac_newSelectedSegmentIndexChannelWithNilValue(0).startWith(0).subscribeNextAs {
                (index: Int) in
                UIView.animateWithDuration(0.05) {
                    switch index {
                        
                    case 0: // Amount
                        self.methodAmountField.placeholder = NSLocalizedString("Amount", comment: "Amount of currency")
                        
                        self.formatter?.configureAmountTextfield(&self.methodAmountField!)
                        
                    case 1: // Percentage
                        self.methodAmountField.placeholder = NSLocalizedString("Percent", comment: "Percent of currency")
                        
                        self.formatter?.configurePercentTextfield(&self.methodAmountField!)
                    default:
                        fatalError("Unimplemented option")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        methodAmountField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
