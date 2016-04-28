//
//  Formatter+UILabel.swift
//  Tippy
//
//  Created by James Pamplona on 4/27/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

extension Formatter {
    func configureAmountTextfield(inout textfield: UITextField) {
        let currencyLabel = UILabel()
        currencyLabel.text = currencySymbol
        switch currencySymbolPosition {
        case .Beginning:
            textfield.leftView = currencyLabel
            textfield.leftViewMode = .Always
            textfield.rightViewMode = .Never
        case .End:
            textfield.rightView = currencyLabel
            textfield.rightViewMode = .Always
            textfield.leftViewMode = .Never
        }
        currencyLabel.sizeToFit()
    }
    
    func configurePercentTextfield(inout textfield: UITextField) {
        let percentLabel = UILabel()
        percentLabel.text = percentSymbol
        switch percentSymbolPosition {
        case .Beginning:
            textfield.leftView = percentLabel
            textfield.leftViewMode = .Always
            textfield.rightViewMode = .Never
        case .End:
            textfield.rightView = percentLabel
            textfield.rightViewMode = .Always
            textfield.leftViewMode = .Never
        }
        percentLabel.sizeToFit()

    }
}