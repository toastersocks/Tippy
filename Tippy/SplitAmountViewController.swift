//
//  SplitAmountViewController.swift
//  Tippy
//
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

public enum Split {
    case amount(Double)
    case percentage(Double)
}

class SplitAmountViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var splitMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var methodAmountField: UITextField!
    
    var splitMethod: Split {
        guard let text = methodAmountField.text else { return .amount(0.0) }
        
        switch splitMethodSegmentedControl.selectedSegmentIndex {
        case 0: // Amount
            return .amount((try? formatter?.currencyFromString(text))??.doubleValue ?? Double(text) ?? 0.0)
        case 1: // Percentage
            return .percentage((try? formatter?.percentageFromString(text))??.doubleValue ?? 0.0)
        default:
            fatalError("Unimplemented option")
        }
    }
    
    var formatter: Formatter? {
        didSet {
            splitMethodSegmentedControl.rac_newSelectedSegmentIndexChannel(withNilValue: 0).start(with: 0).subscribeNextAs {
                (index: Int) in
                UIView.animate(withDuration: 0.05, animations: {
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
                }) 
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
