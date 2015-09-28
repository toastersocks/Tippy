//
//  ColorStackView.swift
//  Animations
//
//  Created by James Pamplona on 9/22/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit

public protocol ColorStackViewDelegate {
    @available(iOS 9.0, *)
    func colorStackView(colorStackView: ColorStackView, didSelectIndex index: Int)
    @available(iOS 9.0, *)
    func numberOfItemsInColorStackView(colorStackView: ColorStackView) -> Int
}


@available(iOS 9.0, *)
@IBDesignable public class ColorStackView: UIControl {

    public var delegate: ColorStackViewDelegate? {
        didSet {
        reload()
        }
    }
    
    public var stackView: UIStackView = UIStackView()
    public var count: Int {
        return stackView.arrangedSubviews.count
    }
    
    public var colors: [UIColor] = [.greenColor(), .redColor(), .blueColor(), .orangeColor()]
    
    func increment() {
        let button = UIButton(type: .System)
        button.backgroundColor = colors[count]
        button.addTarget(self, action: "handleTap:", forControlEvents: .TouchUpInside)
        
        stackView.addArrangedSubview(button)
    }
    
    func decrement() {
        stackView.arrangedSubviews[count-1].removeFromSuperview()
    }
    
    @IBAction func handleTap(sender: UIButton) {
        guard let index = stackView.arrangedSubviews.indexOf(sender) else { fatalError("Index not in arranged subviews") }
        delegate?.colorStackView(self, didSelectIndex: index)
    }
    
    func reload() {
        guard let numberOfItems = delegate?.numberOfItemsInColorStackView(self) else { return }
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        (0..<numberOfItems).forEach {
            (_: Int) in
            increment()
        }
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
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|",
            options: [NSLayoutFormatOptions.DirectionLeftToRight],
            metrics: nil,
            views: ["stackView":stackView]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|",
            options: [NSLayoutFormatOptions.DirectionLeftToRight],
            metrics: nil,
            views: ["stackView":stackView]))
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
