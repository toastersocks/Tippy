//
//  StaticTipoutView.swift
//  Tippy
//
//  Created by James Pamplona on 10/20/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

@IBDesignable open class StaticTipoutView: UIControl {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(viewTag: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup(viewTag: 0)
    }
    
    func xibSetup(viewTag: Int) {
        view = loadViewFromXib(viewTag: viewTag)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromXib(viewTag: Int) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: "StaticTipoutView", bundle: bundle)
        // make sure we load correct view by tag in case there's multiple objects in the xib
        guard let view = (xib.instantiate(withOwner: self, options: nil) as? [UIView])?
            .filter({
                return $0.tag == viewTag ? true : false
                
            })
            .last else { fatalError("Cannot load view from Xib") }
        
        return view
    }
}
