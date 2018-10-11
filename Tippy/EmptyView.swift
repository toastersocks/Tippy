//
//  EmptyView.swift
//  Tippy
//
//  Created by James Pamplona on 9/9/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    var contentView: UIView!
    
    @IBOutlet weak var arrowShapeView: ArrowShapeView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override var tintColor: UIColor! {
        didSet {
            arrowShapeView.tintColor = tintColor
            messageLabel.textColor = tintColor
        }
    }
    
   
    func setupView() {
        contentView = Bundle.main.loadNibNamed(String(describing: EmptyView.self), owner: self, options: nil)?[0] as! UIView
        contentView.frame = self.frame
        addSubview(contentView)
        arrowShapeView.tintColor = tintColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
