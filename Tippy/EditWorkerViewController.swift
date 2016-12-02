//
//  EditWorkerViewController.swift
//  Tippy
//
//  Created by James Pamplona on 10/6/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class EditWorkerViewController: UIViewController {
    var formatter: Formatter?
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var tipoutField: UITextField!
    @IBOutlet weak var methodPicker: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: WorkerViewModelType? {
        didSet {
            if viewModel != nil {
                title = NSLocalizedString("Edit Worker", comment: "Edit a worker in the table view")
            } else {
                title = NSLocalizedString("New Worker", comment: "Create a new worker in the table view")
            }
        }
    }
    
    override var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var currentMethodIndex: Int {
        return methodPicker.selectedSegmentIndex
    }
    
    var currentValue: String? {
        return tipoutField.text
    }
    
    let tipoutMethods = [NSLocalizedString("Hourly", comment: ""),
                         NSLocalizedString("Percentage", comment: ""),
                         NSLocalizedString("Amount", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        methodPicker.addTarget(self, action: #selector(EditWorkerViewController.methodSelected(_:)), forControlEvents: .ValueChanged)
        nameField.text = viewModel?.name
        methodPicker.selectedSegmentIndex = viewModel?.method.rawValue ?? UISegmentedControlNoSegment
        tipoutField.text = viewModel?.value
        
        if viewModel != nil {
            title = NSLocalizedString("Edit Worker", comment: "Edit a worker in the table view")
        } else {
            title = NSLocalizedString("New Worker", comment: "Create a new worker in the table view")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EditWorkerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipoutMethods.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipoutMethods[row]
    }
    
    func methodSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0: // Hourly
            break
        case 1: // Percent
            formatter?.configurePercentTextfield(&tipoutField!)
        case 2: // Amount
            formatter?.configureAmountTextfield(&tipoutField!)
        default:
            fatalError("Unknown value for tipout method")
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0: // Hourly
            break
        case 1: // Percent
            formatter?.configurePercentTextfield(&tipoutField!)
        case 2: // Amount
            formatter?.configureAmountTextfield(&tipoutField!)
        default:
            fatalError("Unknown value for tipout method")
        }
    }
}