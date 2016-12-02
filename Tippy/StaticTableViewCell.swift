//
//  StaticTableViewCell.swift
//  Tippy
//
//  Created by James Pamplona on 11/16/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class StaticTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workerView: StaticTipoutView!
    
    dynamic var viewModel: WorkerViewModelType! {
        didSet {
//            viewModel.formatter?.configureAmountTextfield(&workerView.amountField!)
//            viewModel.formatter?.configurePercentTextfield(&workerView.percentageField!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RAC(workerView, "nameLabel.text") <~ RACObserve(self, "viewModel.name")
        
        RAC(workerView, "amountLabel.text") <~ RACObserve(self, "viewModel.amount")
        
        RAC(workerView, "hoursLabel.text") <~ RACObserve(self, "viewModel.hours")
        
        RAC(workerView, "percentLabel.attributedText") <~ RACObserve(self, "viewModel.percentage")
    }
    
}
