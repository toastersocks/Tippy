//
//  ViewController.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var workerTipoutLabels: [UILabel]!
    @IBOutlet var workersHoursFields: [UITextField]!
    @IBOutlet weak var kitchenTipoutLabel: UILabel!
    @IBOutlet weak var totalField: UITextField!
    
    @IBOutlet var calculationMethods: [UIButton]!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        workersHoursFields.map {
            (textField: UITextField) in
                textField.rac_textSignal()
                .subscribeNextAs { (hours: String) in
                    self.viewModel.setWorkersHours(self.workersHoursFields.map { $0.text })
                }
        }


        viewModel.workersTipoutsSignal
        .subscribeNextAs {
            
        (tipouts: NSArray) in
            
            map(enumerate(tipouts)) {
                
            (index, tipout) in
                
                self.workerTipoutLabels[index].text = tipout as? String
            }
        }

        
        
        RAC(kitchenTipoutLabel, "text") <~ viewModel.kitchenTipoutSignal
        
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

