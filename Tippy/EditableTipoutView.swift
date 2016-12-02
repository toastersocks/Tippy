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
    func tipoutViewDidEndEditing(_ tipoutView: EditableTipoutView)
    
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
    func tipoutView(_ tipoutView: EditableTipoutView, textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    func tipoutViewDidBeginEditing(_ tipoutView: EditableTipoutView, textField: UITextField)
    func tipoutView(_ tipoutView: EditableTipoutView, textField: UITextField, textDidChange text: String)
}

@objc public enum TipoutViewField: Int {
    case name = 0
    case hours = 1
    case percentage
    case amount
}

/// A view for displaying text and receiving input concerning the tips of a worker.
@IBDesignable open class EditableTipoutView: UIControl, UITextFieldDelegate {
    
    fileprivate var view: UIView!
    
    open var delegate: TipoutViewDelegate?
    
    @IBOutlet weak open var amountField: UITextField!
    @IBOutlet weak open var percentageField: UITextField!
    @IBOutlet weak open var hoursField: UITextField!
    
    @IBOutlet weak open var nameField: UITextField!
    
    /// The text field which was last edited. (Either the `amountField`, `percentageField`, or `hoursField`). Excludes `nameField`.
    open var activeTextField: UITextField? {
        didSet {
            colorFields()
        }
    }
    
     /// The text fields which have not been last edited (excluding `nameField`)
    fileprivate var inactiveFields: Set<UITextField> {
        let activeSet: Set<UITextField>
        var inactiveFields: Set<UITextField> = []
        
        if let active = activeTextField {
            activeSet = [active]
        } else {
            activeSet = []
        }
        if let amount = amountField, let percentage = percentageField, let hours = hoursField {
            inactiveFields = Set([amount, percentage, hours])
                .subtracting(activeSet)
        }
        return inactiveFields
    }
    
    /// Indicates if the `activeTextField` should be set on text changes (`true`), or when editing is finished (`false`)
    @IBInspectable var activeOnChange: Bool = false
    
    /// Whether the text in the `inactiveFields` should be cleared when another text field becomes active.
    @IBInspectable var clearsInactiveFields: Bool = false
    
    /// The background color of the active field.
    @IBInspectable var activeColor: UIColor = .white {
        didSet{
            activeTextField?.backgroundColor = activeColor
        }
    }
    
    /// The background color of the inactive text fields.
    @IBInspectable var inactiveColor: UIColor = .white {
        didSet {
            colorFields()
        }
    }
    
    fileprivate func handleInputEvent(textField tag: TipoutViewField, text: String) {
        
            switch tag {
            case .amount:
                activeTextField = amountField
            case .percentage:
                activeTextField = percentageField
            case .hours:
                activeTextField = hoursField
            case .name: return
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
    
    
    @IBAction func textDidChange(_ sender: UITextField) {
        if let isEmpty = sender.text?.isEmpty,  isEmpty == true {
            sender.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        } else if sender.text == nil {
            sender.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        } else {
            sender.self.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
            
        }
        sender.invalidateIntrinsicContentSize()
        if activeOnChange {
            guard let tag = TipoutViewField(rawValue: sender.tag), let text = sender.text else { return }
            handleInputEvent(textField: tag, text: text)
            delegate?.tipoutView(self, textField: sender, textDidChange: text)
        }
    }
    
    // MARK: Delegate
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        if !activeOnChange {
            guard let tag = TipoutViewField(rawValue: textField.tag) else { return }
            handleInputEvent(textField: tag, text: textField.text ?? "")
        }
        delegate?.tipoutViewDidEndEditing(self)
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        delegate?.tipoutViewDidBeginEditing(self, textField: textField)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           return delegate?.tipoutView(self, textField: textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
        
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    
    func xibSetup(viewTag: Int) {
        view = loadViewFromXib(viewTag: viewTag)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromXib(viewTag: Int) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: "EditableTipoutView", bundle: bundle)
        // make sure we load correct view by tag in case there's multiple objects in the xib
        guard let view = (xib.instantiate(withOwner: self, options: nil) as? [UIView])?
            .filter({
            return $0.tag == viewTag ? true : false
                
            })
            .last else { fatalError("Cannot load view from Xib") }
        
        return view
    }
    
    // MARK: - UIView
    
    override open func didMoveToSuperview() {
        
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
