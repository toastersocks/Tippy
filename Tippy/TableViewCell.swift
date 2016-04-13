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
    
    dynamic var viewModel: WorkerViewModelType! {
        didSet {
            let currencyLabel = UILabel()
            currencyLabel.text = self.viewModel.currencySymbol
            switch self.viewModel.currencySymbolPosition {
            case .Beginning:
                self.workerView.amountField.leftView = currencyLabel
                self.workerView.amountField.leftViewMode = .Always
                self.workerView.amountField.rightViewMode = .Never
            case .End:
                self.workerView.amountField.rightView = currencyLabel
                self.workerView.amountField.rightViewMode = .Always
                self.workerView.amountField.leftViewMode = .Never
            default:
                break
            }
            currencyLabel.sizeToFit()
            
            let percentLabel = UILabel()
            percentLabel.text = self.viewModel.percentSymbol
            switch self.viewModel.percentSymbolPosition {
            case .Beginning:
                self.workerView.percentageField.leftView = percentLabel
                self.workerView.percentageField.leftViewMode = .Always
                self.workerView.percentageField.rightViewMode = .Never
            case .End:
                self.workerView.percentageField.rightView = percentLabel
                self.workerView.percentageField.rightViewMode = .Always
                self.workerView.percentageField.leftViewMode = .Never
            default:
                break
            }
            percentLabel.sizeToFit()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RAC(workerView, "nameField.text") <~ RACObserve(self, "viewModel.name").filter { _ in
            return !self.workerView.nameField.isFirstResponder()
        }
        
        RAC(workerView, "amountField.text") <~ RACObserve(self, "viewModel.amount").filter { _ in
            return !self.workerView.amountField.isFirstResponder()
        }
        
        RAC(workerView, "hoursField.text") <~ RACObserve(self, "viewModel.hours").filter { _ in
            return !self.workerView.hoursField.isFirstResponder()
        }
        
        RAC(workerView, "percentageField.attributedText") <~ RACObserve(self, "viewModel.percentage")
            .doNext { _ in
                if self.workerView.percentageField.isFirstResponder() {
                    self.workerView.percentageField.textColor = .blackColor()
                }
            }
            .filter { _ in
                return !self.workerView.percentageField.isFirstResponder()
        }
    }
}
