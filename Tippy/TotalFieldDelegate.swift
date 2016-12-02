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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if let formattedText = try? formatter.formatCurrencyString(text, stripSymbol: true) {
            textField.text = formattedText
        }
        textField.invalidateIntrinsicContentSize()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString: NSString = textField.text as NSString? ?? ""
        let newString = oldString.replacingCharacters(in: range, with: string)
        if !newString.isEmpty {
            do {
                try formatter?.currencyFromString(newString)
            } catch {
                return false
            }
        }
        return true
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        sender.invalidateIntrinsicContentSize()
    }
    /*init(formatter: Formatter) {
    self.formatter = formatter
    super.init()
    }*/
}
