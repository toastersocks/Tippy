//
//  TableViewCell.swift
//  Tippy
//
//  Created by James Pamplona on 7/29/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var workerView: TipoutView!
    
    dynamic var viewModel: WorkerViewModelType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RAC(workerView, "nameField.text") <~ RACObserve(self, "viewModel.name")
        
        RAC(workerView, "amountField.text") <~ RACObserve(self, "viewModel.amount").filter {
            (_: AnyObject!) in
            if let activeTextField = self.workerView?.activeTextField {
                return activeTextField != self.workerView.amountField
            } else {
                return true
            }
        }
        
        RAC(workerView, "hoursField.text") <~ RACObserve(self, "viewModel.hours").filter {
            (_: AnyObject!) in
            if let activeTextField = self.workerView?.activeTextField {
                return activeTextField != self.workerView.hoursField
            } else {
                return true
            }
        }
        
        RAC(workerView, "percentageField.attributedText") <~ RACObserve(self, "viewModel.percentage").filter {
            (_: AnyObject!) in
            if let activeTextField = self.workerView?.activeTextField {
                return activeTextField != self.workerView.percentageField
            } else {
                return true
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
