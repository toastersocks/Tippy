//
//  EditableTableViewCell.swift
//  Tippy
//
//  Created by James Pamplona on 7/29/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa

class EditableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workerView: EditableTipoutView!
    
    @objc dynamic var viewModel: WorkerViewModelType! {
        didSet {
            viewModel.formatter?.configureAmountTextfield(&workerView.amountField!)
            viewModel.formatter?.configurePercentTextfield(&workerView.percentageField!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RAC(workerView, "nameField.text") <~ RACObserve(self, "viewModel.name").filter { _ in
            return !self.workerView.nameField.isFirstResponder
        }
        
        RAC(workerView, "amountField.text") <~ RACObserve(self, "viewModel.amount").filter { _ in
            return !self.workerView.amountField.isFirstResponder
        }
        
        RAC(workerView, "hoursField.text") <~ RACObserve(self, "viewModel.hours").filter { _ in
            return !self.workerView.hoursField.isFirstResponder
        }
        
        RAC(workerView, "percentageField.attributedText") <~ RACObserve(self, "viewModel.percentage")
            .doNext { _ in
                if self.workerView.percentageField.isFirstResponder {
                    self.workerView.percentageField.textColor = .black
                }
            }
            .filter { _ in
                return !self.workerView.percentageField.isFirstResponder
        }
    }
}
