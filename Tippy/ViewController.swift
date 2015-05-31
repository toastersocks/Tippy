//
//  ViewController.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var workerTipoutLabels: [UILabel]!
    @IBOutlet var workersHoursFields: [UITextField]!
    @IBOutlet weak var kitchenTipoutLabel: UILabel!
    @IBOutlet weak var totalField: UITextField!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       // totalField.delegate = self
        
        RACObserve(viewModel, "workersHours")
            .subscribeNextAs {
                (hoursArray: NSArray) in
                map(enumerate(self.viewModel.workersHours)) {
                    (index, hours) in
                    workerTipoutLabels[index].text = viewModel.workersHours[index]
                }
        }
        
        workersHoursFields.map {
            (textField: UITextField)  in
            RACSignal.merge([textField.rac_textSignal(), self.totalField.rac_textSignal()])
                .subscribeNextAs {
                (text: NSString) -> () in
//                debugPrintln(text)
                self.viewModel.workersHours =
                    self.workersHoursFields
                    .map { $0.text }
                map(enumerate(self.workerTipoutLabels)) {
                    (index: Int, label: UILabel) -> Void in
//                    debugPrintln(self.viewModel.workersTipouts[index])
                    label.text = self.viewModel.workersTipouts[index]
                }
                return ()
            }
        }
        

        
//        RACObserve(self, "workersHoursFields")
//            .subscribeNextAs {
//                (textFields: [UITextField]) in
//                textFields.map {debugPrintln($0.text)}
//        }
        
        RACObserve(viewModel, "totalText")
            .subscribeNextAs { (total: String) in
            self.kitchenTipoutLabel.text = self.viewModel.kitchenTipoutText
        }
        
        RAC(viewModel, "totalText") <~ totalField.rac_textSignal()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

