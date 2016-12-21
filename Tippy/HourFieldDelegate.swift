    //
//  HourFieldDelegate.swift
//  Tippy
//
//  Created by James Pamplona on 12/16/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class HourFieldDelegate: TextFieldDelegate {

    override func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if let formattedText = try? formatter.formatNumberString(text) {
            textField.text = formattedText
        }
        textField.invalidateIntrinsicContentSize()
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text as NSString? ?? ""
        let newString = oldString.replacingCharacters(in: range, with: string)
        
        return newString.isEmpty ? true : formatter.isHoursTextValid(text: newString)
    }

}
