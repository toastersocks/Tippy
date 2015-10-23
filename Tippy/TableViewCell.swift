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
    
    var viewModel: WorkerViewModelType = WorkerViewModelType(name: "", method: "amount", value: "0") {
        didSet {
            RAC(workerView, "nameField.text") <~ viewModel.rac_nameTextSignal()
            
            RAC(workerView, "amountField.text") <~ viewModel.rac_amountTextSignal().filter {
                (_: AnyObject!) in
                if let activeTextField = self.workerView?.activeTextField {
                    return activeTextField != self.workerView.amountField
                } else {
                    return true
                }
            }
            
            RAC(workerView, "hoursField.text") <~ viewModel.rac_hoursTextSignal().filter {
                (_: AnyObject!) in
                if let activeTextField = self.workerView?.activeTextField {
                    return activeTextField != self.workerView.hoursField
                } else {
                    return true
                }
            }
            
            RAC(workerView, "percentageField.attributedText") <~ viewModel.rac_percentageTextSignal().filter {
                (_: AnyObject!) in
                if let activeTextField = self.workerView?.activeTextField {
                    return activeTextField != self.workerView.percentageField
                } else {
                    return true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
