//
//  TotalFieldDelegate.swift
//  Tippy
//
//  Created by James Pamplona on 12/17/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit

class TotalFieldDelegate: NSObject, UITextFieldDelegate {
    
    @IBOutlet weak var formatter: Formatter!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let text = textField.text else { return }
        if let formattedText = try? formatter.formatCurrencyString(text) {
            textField.text = formattedText
        }
        textField.invalidateIntrinsicContentSize()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text ?? ""
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
        if !newString.isEmpty {
            do {
                try formatter?.currencyFromString(newString)
            } catch {
                return false
            }
        }
        return true
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        sender.invalidateIntrinsicContentSize()
    }
    /*init(formatter: Formatter) {
    self.formatter = formatter
    super.init()
    }*/
}