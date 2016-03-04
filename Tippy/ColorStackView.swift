//
//  ColorStackView.swift
//  Animations
//
//  Created by James Pamplona on 9/22/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import TZStackView

public protocol ColorStackViewDelegate {

    func colorStackView(colorStackView: ColorStackView, didSelectIndex index: Int)
    func colorStackView(colorStackView: ColorStackView, shouldSelectIndex index: Int) -> Bool
    func numberOfItemsInColorStackView(colorStackView: ColorStackView) -> Int
    func currentIndexOfColorStackView(colorStackView: ColorStackView) -> Int
}

@objc public protocol ColorStackViewColorDelegate {
    func colorForIndex(index:Int) -> UIColor
}

@IBDesignable public class ColorStackView: UIControl {

    public var delegate: ColorStackViewDelegate? {
        didSet {
//        reload()
        }
    }
    
    @IBOutlet public var colorDelegate: ColorStackViewColorDelegate? {
        didSet {
//            reload()
        }
    }
    
    public var stackView = TZStackView()
    public var count: Int {
        return stackView.arrangedSubviews.count
    }
    
    public var colors: [UIColor] = [.greenColor(), .redColor(), .blueColor(), .orangeColor()]
    
    private func animationStartEndPositionConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: stackView, attribute: .Height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: stackView, attribute: .Trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: stackView, attribute: .Top, multiplier: 1, constant: 0)
        ]
}
    
    func increment(animated animated: Bool) {
        let button = UIButton(type: .System)
        button.addTarget(self, action: "handleTap:", forControlEvents: .TouchUpInside)
        button.backgroundColor = colorDelegate?.colorForIndex(count) ?? colors[count % colors.count]
        self.stackView.addArrangedSubview(button)
        
        if animated {
        let animationStartConstraints = animationStartEndPositionConstraintsWithView(button)
        button.hidden = true
        stackView.addConstraints(animationStartConstraints)
        stackView.layoutIfNeeded()
        
        UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
            self.stackView.removeConstraints(animationStartConstraints)
            self.stackView.layoutIfNeeded()
            button.hidden = false
            }, completion: nil)
        }
    }
    
    func decrement(animated animated: Bool) {
        guard let viewToRemove = stackView.arrangedSubviews.last else { return }
        if animated {
            let animatedEndConstraints = animationStartEndPositionConstraintsWithView(viewToRemove)
            UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
                self.stackView.addConstraints(animatedEndConstraints)
                self.stackView.layoutIfNeeded()
                viewToRemove.hidden = true
                }, completion: nil)
            
            viewToRemove.removeFromSuperview()
            
            
        }
    }
    
    @IBAction func handleTap(sender: UIButton) {
        guard let index = stackView.arrangedSubviews.indexOf(sender) else { fatalError("Index not in arranged subviews") }
        guard let delegate = delegate where delegate.colorStackView(self, shouldSelectIndex: index) == true else { return }
        delegate.colorStackView(self, didSelectIndex: index)
        backgroundColor = colorDelegate?.colorForIndex(index)
    }
    
    func reload() {
        guard let numberOfItems = delegate?.numberOfItemsInColorStackView(self) else { return }
        
        let diff = numberOfItems - count
        
        if diff > 0 {
            (0..<diff).forEach {
                (_: Int) in
                increment(animated: true)
            }
        } else if diff < 0 {
            (0..<abs(diff)).forEach {
                (_: Int) in
                decrement(animated: true)
            }
        }
        
        guard let delegate = delegate else { return }
        
        stackView.arrangedSubviews.enumerate().forEach {
            index, button in
            button.backgroundColor = colorDelegate?.colorForIndex(index) ?? colors[index % colors.count]
        }
        
        backgroundColor = colorDelegate?.colorForIndex(delegate.currentIndexOfColorStackView(self))
    }
    
    // MARK: - Init stuff
    func setup(frame: CGRect) {

        stackView.frame = self.frame
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 0

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]-10-|",
            options: [NSLayoutFormatOptions.DirectionLeftToRight],
            metrics: nil,
            views: ["stackView":stackView]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|",
            options: [NSLayoutFormatOptions.DirectionLeftToRight],
            metrics: nil,
            views: ["stackView":stackView]))
        
        backgroundColor = UIColor.redColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(frame)
    }
}
