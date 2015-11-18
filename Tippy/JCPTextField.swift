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

    override func intrinsicContentSize() -> CGSize {
        if let text = self.text where !text.isEmpty {
            let textSize = (text as NSString).sizeWithAttributes(typingAttributes)
            return CGSize(
                width: textSize.width +
                    (rightView?.bounds.size.width ?? 0) +
                    (leftView?.bounds.size.width ?? 0) +
                    25, // size of caret
                height: super.intrinsicContentSize().height)
        } else {
            return super.intrinsicContentSize()
        }
    }
    
    func tableViewCell() -> UIView? {
        var aView: UIView? = superview
        
        while !(aView is UITableView) && aView != nil {
            aView = aView?.superview
        }
        /*while var aView: UIView? = superview where !(aView is UITableViewCell) {
            aView = superview
        }*/
        
//        guard let cell = aView as? TableViewCell else { fatalError("Wrong cell type. Expected a TableViewCell") }
        return aView
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tableViewCell()?.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tableViewCell()?.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tableViewCell()?.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        tableViewCell()?.touchesCancelled(touches, withEvent: event)
    }
}
