//
//  TipoutView.swift
//  Tippy
//
//  Created by James Pamplona on 7/19/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import TZStackView


/**
*  Used to notify delegates of events such as text being edited.
*/
public protocol TipoutViewDelegate {
    /**
    Tells the delegate that a text field in the `TipoutView` has been edited and resigned.
    
    - parameter tipoutView: The `TipoutView` that was edited

    */
    func tipoutViewDidEndEditing(tipoutView: EditableTipoutView)
    
    /**
    Asks the delegate if the specified text should be changed
    
    - parameter tipoutView: The `TipoutView` containing the text field with text to be changed.
    - parameter textField:  The textfield which has the changed text
    - parameter range:      The range of characters to be replaced
    - parameter string:     The replacement string
    
    - returns: `true` if the text range should be raplaced. `false` if it should be kept the same
    
    - note: This basically forwards the respective `UITextFieldDelegate` calls
    - seeAlso: `UITextFieldDelegate`
    */
    func tipoutView(tipoutView: EditableTipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    func tipoutViewDidBeginEditing(tipoutView: EditableTipoutView, textField: UITextField)
    func tipoutView(tipoutView: EditableTipoutView, textField: UITextField, textDidChange text: String)
}

@objc public enum TipoutViewField: Int {
    case Name = 0
    case Hours = 1
    case Percentage
    case Amount
}

/// A view for displaying text and receiving input concerning the tips of a worker.
@IBDesignable public class EditableTipoutView: UIControl, UITextFieldDelegate {
    
    private var view: UIView!
    
    public var delegate: TipoutViewDelegate?
    
    @IBOutlet weak public var amountField: UITextField!
    @IBOutlet weak public var percentageField: UITextField!
    @IBOutlet weak public var hoursField: UITextField!
    
    @IBOutlet weak public var nameField: UITextField!
    
    /// The text field which was last edited. (Either the `amountField`, `percentageField`, or `hoursField`). Excludes `nameField`.
    public var activeTextField: UITextField? {
        didSet {
            colorFields()
        }
    }
    
     /// The text fields which have not been last edited (excluding `nameField`)
    private var inactiveFields: Set<UITextField> {
        let activeSet: Set<UITextField>
        var inactiveFields: Set<UITextField> = []
        
        if let active = activeTextField {
            activeSet = [active]
        } else {
            activeSet = []
        }
        if let amount = amountField, percentage = percentageField, hours = hoursField {
            inactiveFields = Set([amount, percentage, hours])
                .subtract(activeSet)
        }
        return inactiveFields
    }
    
    /// Indicates if the `activeTextField` should be set on text changes (`true`), or when editing is finished (`false`)
    @IBInspectable var activeOnChange: Bool = false
    
    /// Whether the text in the `inactiveFields` should be cleared when another text field becomes active.
    @IBInspectable var clearsInactiveFields: Bool = false
    
    /// The background color of the active field.
    @IBInspectable var activeColor: UIColor = .whiteColor() {
        didSet{
            activeTextField?.backgroundColor = activeColor
        }
    }
    
    /// The background color of the inactive text fields.
    @IBInspectable var inactiveColor: UIColor = .whiteColor() {
        didSet {
            colorFields()
        }
    }
    
    private func handleInputEvent(textField tag: TipoutViewField, text: String) {
        
            switch tag {
            case .Amount:
                activeTextField = amountField
            case .Percentage:
                activeTextField = percentageField
            case .Hours:
                activeTextField = hoursField
            case .Name: return
        }
            if clearsInactiveFields {
                clearInactiveFields()
            }
        
    }
    
    func colorFields() {
        amountField?.backgroundColor = inactiveColor
        percentageField?.backgroundColor = inactiveColor
        hoursField?.backgroundColor = inactiveColor
        activeTextField?.backgroundColor = activeColor
    }
    
    func clearInactiveFields() {
        inactiveFields.forEach {
            $0.text = ""
        }
    }
    
    
    @IBAction func textDidChange(sender: UITextField) {
        if let isEmpty = sender.text?.isEmpty where  isEmpty == true {
            sender.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        } else if sender.text == nil {
            sender.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        } else {
            sender.self.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
            
        }
        sender.invalidateIntrinsicContentSize()
        if activeOnChange {
            guard let tag = TipoutViewField(rawValue: sender.tag), text = sender.text else { return }
            handleInputEvent(textField: tag, text: text)
            delegate?.tipoutView(self, textField: sender, textDidChange: text)
        }
    }
    
    // MARK: Delegate
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if !activeOnChange {
            guard let tag = TipoutViewField(rawValue: textField.tag) else { return }
            handleInputEvent(textField: tag, text: textField.text ?? "")
        }
        delegate?.tipoutViewDidEndEditing(self)
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(nil)
        delegate?.tipoutViewDidBeginEditing(self, textField: textField)
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
           return delegate?.tipoutView(self, textField: textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
        
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - init
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }*/
    
    required public init?(coder aDecoder: NSCoder) {
//        viewTag = 4
        super.init(coder: aDecoder)
        xibSetup(viewTag: 4)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        amountField.delegate = self
        percentageField.delegate = self
        hoursField.delegate = self
        nameField.delegate = self
        
        amountField.backgroundColor = inactiveColor
        percentageField.backgroundColor = inactiveColor
        hoursField.backgroundColor = inactiveColor
    }
    
    
    func xibSetup(viewTag viewTag: Int) {
        view = loadViewFromXib(viewTag: viewTag)
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromXib(viewTag viewTag: Int) -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let xib = UINib(nibName: "EditableTipoutView", bundle: bundle)
        // make sure we load correct view by tag in case there's multiple objects in the xib
        guard let view = (xib.instantiateWithOwner(self, options: nil) as? [UIView])?
            .filter({
            return $0.tag == viewTag ? true : false
                
            })
            .last else { fatalError("Cannot load view from Xib") }
        
        return view
    }
    
    // MARK: - UIView
    
    override public func didMoveToSuperview() {
        
        colorFields()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}