//
//  JCPTextField.swift
//  JCPTextFieldRig
//
//  Created by James Pamplona on 11/11/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit

class JCPTextField: UITextField {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override var intrinsicContentSize : CGSize {
        
        if let text = self.text, !text.isEmpty {
            let textSize = (text as NSString).size(attributes: typingAttributes)
            let width = textSize.width +
                (rightView?.bounds.size.width ?? 0) +
                (leftView?.bounds.size.width ?? 0) +
                25 //!!!: where does this extra needed space come from?
            let size = CGSize(width: width, height: super.intrinsicContentSize.height)
            return size
        } else {
            return super.intrinsicContentSize
        }
    }
    
}
