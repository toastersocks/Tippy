//
//  ArrowShapeView.swift
//  Tippy
//
//  Created by James Pamplona on 9/9/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

@IBDesignable class ArrowShapeView: UIView {

    override var tintColor: UIColor! {
        didSet {
            arrowLayer.strokeColor = tintColor.cgColor
//            arrowLayer.fillColor = tintColor.CGColor
        }
    }
    
    var arrowLayer = CAShapeLayer()
    
    func arrowPath(inRect rect: CGRect) -> UIBezierPath {
        
        let arrowHeight = rect.maxY
        let arrowWidth = rect.width
        let arrowHeadHeight = arrowHeight * 0.6
        let arrowHeadWidth = arrowWidth * 1.0
//        let arrowBaseHeight = arrowHeight * 0.5
        let arrowBaseWidth = arrowWidth * 0.5
        
        let leftHeadPoint = CGPoint(x: rect.minX, y: arrowHeadHeight)
        let rightHeadPoint = CGPoint(x: arrowHeadWidth, y: arrowHeadHeight)
        let arrowHeadTipPoint = CGPoint(x: arrowHeadWidth * 0.5, y: 0.0)
        let leftHeadBaseIntersectPoint = CGPoint(x: arrowBaseWidth * 0.5, y: arrowHeadHeight)
        let leftBasePoint = CGPoint(x: leftHeadBaseIntersectPoint.x, y: CGFloat(arrowHeight))
        let rightBasePoint = CGPoint(x: leftBasePoint.x + CGFloat(arrowBaseWidth), y: CGFloat(arrowHeight))
        let rightHeadBaseIntersectPoint = CGPoint(x: rightBasePoint.x, y: CGFloat(arrowHeadHeight))
        
        let path = UIBezierPath()
        
        path.move(to: leftHeadPoint)
        path.addLine(to: arrowHeadTipPoint)
        path.addLine(to: rightHeadPoint)
        path.addLine(to: rightHeadBaseIntersectPoint)
        path.addLine(to: rightBasePoint)
        path.addLine(to: leftBasePoint)
        path.addLine(to: leftHeadBaseIntersectPoint)
        path.close()
        
        return path
    }
    
    func setupView() {
        
        arrowLayer.path = arrowPath(inRect: layer.bounds).cgPath
        arrowLayer.strokeColor = tintColor.cgColor
        arrowLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(arrowLayer)

    }
    
    override func layoutSublayersOfLayer(_ layer: CALayer) {
        if layer == self.layer {
            arrowLayer.path = arrowPath(inRect: self.layer.bounds).cgPath
        }
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
