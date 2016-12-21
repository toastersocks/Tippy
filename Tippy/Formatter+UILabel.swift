//
//  Formatter+UILabel.swift
//  Tippy
//
//  Created by James Pamplona on 4/27/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

extension Formatter {
    func configureAmountTextfield(_ textfield: inout UITextField) {
        let currencyLabel = UILabel()
        currencyLabel.text = currencySymbol
        switch currencySymbolPosition {
        case .beginning:
            textfield.leftView = currencyLabel
            textfield.leftViewMode = .always
            textfield.rightViewMode = .never
        case .end:
            textfield.rightView = currencyLabel
            textfield.rightViewMode = .always
            textfield.leftViewMode = .never
        }
        currencyLabel.sizeToFit()
    }
    
    func configurePercentTextfield(_ textfield: inout UITextField) {
        let percentLabel = UILabel()
        percentLabel.text = percentSymbol
        switch percentSymbolPosition {
        case .beginning:
            textfield.leftView = percentLabel
            textfield.leftViewMode = .always
            textfield.rightViewMode = .never
        case .end:
            textfield.rightView = percentLabel
            textfield.rightViewMode = .always
            textfield.leftViewMode = .never
        }
        percentLabel.sizeToFit()

    }
    
    func configureHoursTextField(_ textfield: inout UITextField) {
        textfield.rightViewMode = .never
        textfield.leftViewMode = .never
    }
}
