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
    
    var viewModel: WorkerViewModel = WorkerViewModel() {
        didSet {
            RACObserve(self.viewModel, "amount").subscribeNextAs {
                (text: String) -> () in
                self.workerView.amountField.text = text
            }
            RACObserve(self.viewModel, "percentage").subscribeNextAs {
                (text: String) -> () in
                self.workerView.percentageField.text = text
            }
            RACObserve(self.viewModel, "hours").subscribeNextAs {
                (text: String) -> () in
                self.workerView.hoursField.text = text
            }
            RACObserve(self.viewModel, "name").subscribeNextAs {
                (text: String) -> () in
                self.workerView.nameField.text = text
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
