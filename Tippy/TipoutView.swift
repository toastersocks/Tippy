//
//  TipoutView.swift
//  Tippy
//
//  Created by James Pamplona on 11/15/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

@objc protocol TextContainer {
    var text: String? { get set }
}

@IBDesignable public class TipoutView: UIControl {
    
    @objc public enum TipoutViewField: Int {
        case Name = 0
        case Hours = 1
        case Percentage
        case Amount
    }

    public var delegate: TipoutViewDelegate?
    var view: UIView!
    
    var name: String?
    var hours: String?
    var percent: String?
    var amount: String?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        xibSetup(viewTag: -1)
//        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        xibSetup(viewTag: -1)
//        setup()
    }
    
    // MARK: - Setup
    
    func setup() { /* Override */ }
    
    func xibSetup(viewTag viewTag: Int) {
        view = loadViewFromXib(viewTag: viewTag)
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }

    func loadViewFromXib(viewTag viewTag: Int) -> UIView {
        let bundle = NSBundle.mainBundle() //NSBundle(forClass: self.dynamicType)
        let xib = UINib(nibName: "TipoutView", bundle: bundle)
        // make sure we load correct view by tag in case there's multiple objects in the xib
        guard let view = (xib.instantiateWithOwner(self, options: nil) as? [UIView])?
            .filter({
                return $0.tag == viewTag ? true : false
                
            })
            .last else { fatalError("Cannot load view from Xib") }
        
        return view
    }

}
